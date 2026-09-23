import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin


STATS_URL = "https://arkansasrazorbacks.com/sport/m-footbl/stats/"


response = requests.get(STATS_URL, timeout=30)
response.raise_for_status()

soup = BeautifulSoup(response.text, "html.parser")

pdf_urls = []

for row in soup.find_all("tr"):
    stats_link = row.find("a", string="Stats")

    if stats_link:
        pdf_url = urljoin(STATS_URL, stats_link["href"])

        if "/stats/football/2025/" in pdf_url:
            pdf_urls.append(pdf_url)


for url in pdf_urls:
    print(url)

print(f"\nPDFs found: {len(pdf_urls)}")