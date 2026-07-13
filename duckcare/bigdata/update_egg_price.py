import os
import re
import json
from datetime import datetime
from pathlib import Path

import requests
from bs4 import BeautifulSoup
from pymongo import MongoClient


# ==========================================================
# KONFIGURASI BIG DATA DUCKCARE
# ==========================================================

MONGODB_URI = os.environ.get("MONGODB_URI")

MONGO_DB_NAME = os.environ.get("MONGO_DB_NAME", "duckcare_bigdata")
MONGO_COLLECTION = os.environ.get("MONGO_COLLECTION", "harga_telur")

SUNEGG_URL = "https://sunegg.id/indeks-harga-telur"

# Harga dasar untuk menghitung indeks harga telur
HARGA_DASAR = 24501

# Lokasi folder tempat file Python ini berada:
# duckcare/bigdata
BASE_DIR = Path(__file__).resolve().parent

# Hasil selalu masuk ke:
# duckcare/bigdata/output
OUTPUT_DIR = BASE_DIR / "output"

OUTPUT_FILE = OUTPUT_DIR / "report_harga_telur.json"


# ==========================================================
# HEADER REQUEST KE WEBSITE
# ==========================================================

HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/120.0.0.0 Safari/537.36"
    ),
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
    "Accept-Language": "id-ID,id;q=0.9,en-US;q=0.8,en;q=0.7",
    "Referer": "https://www.google.com/",
    "Connection": "keep-alive",
}
# ==========================================================
# FUNGSI SCRAPING SUNEGG
# ==========================================================

def fetch_halaman(url: str):
    try:
        response = requests.get(url, headers=HEADERS, timeout=20)
        response.raise_for_status()

        soup = BeautifulSoup(response.text, "html.parser")

        print(f"Berhasil mengambil halaman: {url}")
        return soup

    except requests.RequestException as error:
        print(f"Gagal mengambil halaman SunEgg: {error}")
        return None


def parse_angka(teks: str):
    if not teks:
        return None

    teks_bersih = re.sub(r"[^\d,.]", "", str(teks))
    teks_bersih = teks_bersih.replace(".", "").replace(",", ".")

    try:
        return float(teks_bersih)
    except ValueError:
        return None


def ambil_harga_nasional(soup):
    teks_halaman = soup.get_text(separator=" ")

    pola_saat_ini = re.search(
        r"Saat\s*Ini\s*Rp([\d.,]+)/kg",
        teks_halaman,
        re.IGNORECASE
    )

    if pola_saat_ini:
        return parse_angka(pola_saat_ini.group(1))

    for elemen in soup.find_all(True):
        teks = elemen.get_text(strip=True)

        if "Rp" in teks and "/kg" in teks:
            angka = parse_angka(teks)

            if angka and 15000 < angka < 40000:
                return angka

    return None

def ambil_statistik_harga(soup):
    teks_halaman = soup.get_text(separator=" ")

    statistik = {
        "harga_tertinggi": None,
        "harga_terendah": None,
        "harga_rata2": None,
        "volatilitas_pct": None,
    }

    pola_tertinggi = re.search(
        r"Tertinggi\s*Rp([\d.,]+)/kg",
        teks_halaman,
        re.IGNORECASE
    )

    pola_terendah = re.search(
        r"Terendah\s*Rp([\d.,]+)/kg",
        teks_halaman,
        re.IGNORECASE
    )

    pola_rata2 = re.search(
        r"Rata-rata\s*Rp([\d.,]+)/kg",
        teks_halaman,
        re.IGNORECASE
    )

    pola_volatilitas = re.search(
        r"Volatilitas\s*([\d.]+)%",
        teks_halaman,
        re.IGNORECASE
    )

    if pola_tertinggi:
        statistik["harga_tertinggi"] = parse_angka(pola_tertinggi.group(1))

    if pola_terendah:
        statistik["harga_terendah"] = parse_angka(pola_terendah.group(1))

    if pola_rata2:
        statistik["harga_rata2"] = parse_angka(pola_rata2.group(1))

    if pola_volatilitas:
        statistik["volatilitas_pct"] = float(pola_volatilitas.group(1))

    return statistik

def ambil_harga_regional(soup):
    teks_halaman = soup.get_text(separator=" ").lower()

    regional = {}

    wilayah_map = {
        "Jabar-DKI": ["jabar", "dki", "jakarta", "jawa barat"],
        "Jawa Tengah": ["jateng", "jawa tengah"],
        "Jawa Timur": ["jatim", "jawa timur"],
        "Luar Jawa": ["luar jawa", "sumatra", "kalimantan", "sulawesi"],
    }

    for nama_wilayah, daftar_kata_kunci in wilayah_map.items():
        for kata_kunci in daftar_kata_kunci:
            pola = re.search(
                rf"{kata_kunci}[^\n]*(\d{{2,3}}\.\d{{3}})",
                teks_halaman
            )

            if pola:
                regional[nama_wilayah] = parse_angka(pola.group(1))
                break

    return regional

def scrape_indeks_harga():
    soup = fetch_halaman(SUNEGG_URL)

    if soup is None:
        raise ValueError("Halaman SunEgg tidak berhasil diambil.")

    harga_nasional = ambil_harga_nasional(soup)

    if harga_nasional is None:
        raise ValueError("Harga nasional tidak ditemukan dari halaman SunEgg.")

    statistik = ambil_statistik_harga(soup)
    regional = ambil_harga_regional(soup)

    data = {
        "tanggal": datetime.now().strftime("%Y-%m-%d"),
        "timestamp": datetime.now().isoformat(),
        "harga_nasional": harga_nasional,
        "harga_tertinggi": statistik["harga_tertinggi"],
        "harga_terendah": statistik["harga_terendah"],
        "harga_rata2": statistik["harga_rata2"],
        "volatilitas_pct": statistik["volatilitas_pct"],
        "indeks": round((harga_nasional / HARGA_DASAR) * 100, 2),
        "regional": regional,
        "sumber": SUNEGG_URL,
    }

    print("Data hasil scraping:")
    print(json.dumps(data, indent=2, ensure_ascii=False))

    return data

# ==========================================================
# FUNGSI KONEKSI MONGODB
# ==========================================================

def koneksi_mongodb():
    if not MONGODB_URI:
        raise ValueError("MONGODB_URI belum tersedia. Isi dulu di GitHub Secrets.")

    client = MongoClient(
        MONGODB_URI,
        serverSelectionTimeoutMS=15000
    )

    client.admin.command("ping")

    print("Koneksi MongoDB Atlas berhasil.")

    return client

def simpan_ke_mongodb(client, data):
    database = client[MONGO_DB_NAME]
    collection = database[MONGO_COLLECTION]

    hasil = collection.update_one(
        {"tanggal": data["tanggal"]},
        {"$set": data},
        upsert=True
    )

    if hasil.upserted_id:
        print(f"Data baru berhasil disimpan: {data['tanggal']}")
    else:
        print(f"Data tanggal {data['tanggal']} berhasil diperbarui.")

        # ==========================================================
# FUNGSI FORMAT REPORT
# ==========================================================

def format_label_tanggal(tanggal_text):
    try:
        tanggal = datetime.strptime(tanggal_text, "%Y-%m-%d")

        nama_bulan = {
            1: "Jan",
            2: "Feb",
            3: "Mar",
            4: "Apr",
            5: "Mei",
            6: "Jun",
            7: "Jul",
            8: "Agu",
            9: "Sep",
            10: "Okt",
            11: "Nov",
            12: "Des",
        }

        return f"{tanggal.day:02d} {nama_bulan[tanggal.month]}"

    except Exception:
        return tanggal_text


def normalize_trend_value(harga, min_harga, max_harga):
    harga = float(harga)
    min_harga = float(min_harga)
    max_harga = float(max_harga)

    if max_harga <= min_harga:
        return 0.5

    nilai = 0.15 + ((harga - min_harga) / (max_harga - min_harga)) * 0.75

    return round(nilai, 2)

def buat_report_json(client, jumlah_hari=30):
    database = client[MONGO_DB_NAME]
    collection = database[MONGO_COLLECTION]

    cursor = collection.find(
        {},
        {"_id": 0}
    ).sort("tanggal", -1).limit(jumlah_hari)

    data_desc = list(cursor)

    if len(data_desc) == 0:
        raise ValueError("Data MongoDB masih kosong. Tidak bisa membuat report.")

    data_urut = list(reversed(data_desc))

    data_awal = data_urut[0]
    data_terbaru = data_urut[-1]

    if len(data_urut) > 1:
        data_sebelumnya = data_urut[-2]
    else:
        data_sebelumnya = data_terbaru

    daftar_harga = []

    for item in data_urut:
        harga = item.get("harga_nasional", 0)

        if harga:
            daftar_harga.append(float(harga))

    harga_min = min(daftar_harga)
    harga_max = max(daftar_harga)
    harga_rata_rata = sum(daftar_harga) / len(daftar_harga)

    harga_awal = float(data_awal.get("harga_nasional", 0))
    harga_terbaru = float(data_terbaru.get("harga_nasional", 0))

    if harga_awal > 0:
        persentase_kenaikan = ((harga_terbaru - harga_awal) / harga_awal) * 100
    else:
        persentase_kenaikan = 0

    trend = []

    for item in data_urut:
        harga_asli = int(round(float(item.get("harga_nasional", 0))))

        trend.append({
            "tanggal": item.get("tanggal", ""),
            "label": format_label_tanggal(item.get("tanggal", "")),
            "value": normalize_trend_value(harga_asli, harga_min, harga_max),
            "harga_asli": harga_asli,
        })

    regional_terbaru = data_terbaru.get("regional", {}) or {}
    regional_sebelumnya = data_sebelumnya.get("regional", {}) or {}

    harga_tertinggi = []

    if len(regional_terbaru) > 0:
        for wilayah, harga in regional_terbaru.items():
            harga_sekarang = int(round(float(harga)))
            harga_lama = int(round(float(regional_sebelumnya.get(wilayah, harga))))

            harga_tertinggi.append({
                "tanggal": format_label_tanggal(data_terbaru.get("tanggal", "")),
                "wilayah": wilayah,
                "harga": harga_sekarang,
                "harga_sebelumnya": harga_lama,
                "selisih": harga_sekarang - harga_lama,
            })
    else:
        harga_sekarang = int(round(harga_terbaru))
        harga_lama = int(round(float(data_sebelumnya.get("harga_nasional", harga_terbaru))))

        harga_tertinggi.append({
            "tanggal": format_label_tanggal(data_terbaru.get("tanggal", "")),
            "wilayah": "Nasional",
            "harga": harga_sekarang,
            "harga_sebelumnya": harga_lama,
            "selisih": harga_sekarang - harga_lama,
        })

    harga_tertinggi.sort(key=lambda item: item["harga"], reverse=True)

    wilayah_options = ["Semua Wilayah"] + list(regional_terbaru.keys())

    report = {
        "success": True,
        "message": "Data report harga telur berhasil diperbarui",
        "code": 200,
        "data": {
            "updated_at": data_terbaru.get("timestamp", ""),
            "sumber": data_terbaru.get("sumber", SUNEGG_URL),
            "satuan": "Rp/kg",
            "periode": f"{jumlah_hari} data terakhir",
            "wilayah_aktif": "Semua Wilayah",
            "summary": {
                "harga_terakhir": int(round(harga_terbaru)),
                "harga_sebelumnya": int(round(float(data_sebelumnya.get("harga_nasional", harga_terbaru)))),
                "harga_rata_rata": int(round(harga_rata_rata)),
                "harga_tertinggi_nasional": int(round(harga_max)),
                "harga_terendah_nasional": int(round(harga_min)),
                "persentase_kenaikan": round(persentase_kenaikan, 1),
                "indeks": float(data_terbaru.get("indeks", 0) or 0),
                "volatilitas_pct": float(data_terbaru.get("volatilitas_pct", 0) or 0),
                "jumlah_data": len(data_urut),
            },
            "trend": trend,
            "harga_tertinggi": harga_tertinggi,
            "wilayah_options": wilayah_options,
        },
    }

    return report

def simpan_report_json(report):
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    with open(OUTPUT_FILE, "w", encoding="utf-8") as file:
        json.dump(report, file, indent=2, ensure_ascii=False)

    print(f"File report berhasil dibuat: {OUTPUT_FILE}")


def main():
    client = None

    try:
        print("Mulai update harga telur DuckCare...")

        client = koneksi_mongodb()

        try:
            data_harga = scrape_indeks_harga()
            simpan_ke_mongodb(client, data_harga)

        except Exception as scrape_error:
            print(f"Scraping SunEgg gagal: {scrape_error}")
            print("Lanjut membuat report dari data MongoDB yang sudah ada.")

        report = buat_report_json(client, jumlah_hari=30)

        simpan_report_json(report)

        print("Update harga telur selesai.")

    except Exception as error:
        print(f"Terjadi error: {error}")
        raise error

    finally:
        if client is not None:
            client.close()
            print("Koneksi MongoDB ditutup.")


if __name__ == "__main__":
    main()