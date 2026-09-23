from datetime import datetime
from io import BytesIO
import re
import pdfplumber
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin

STATS_URL = "https://arkansasrazorbacks.com/sport/m-footbl/stats/"
TARGET_OPPONENT = "Alabama A&M"

# Find Alabama A&M PDF
response = requests.get(STATS_URL, timeout=30)
response.raise_for_status()

soup = BeautifulSoup(response.text, "html.parser")

pdf_url = None

for row in soup.find_all("tr"):
    if TARGET_OPPONENT in row.get_text(" ", strip=True):
        stats_link = row.find("a", string="Stats")

        if stats_link:
            pdf_url = urljoin(STATS_URL, stats_link["href"])
            break

if pdf_url is None:
    raise ValueError("Could not find Alabama A&M stats PDF")


# Download PDF into memory
response = requests.get(pdf_url, timeout=30)
response.raise_for_status()

with pdfplumber.open(BytesIO(response.content)) as pdf:
    text = pdf.pages[0].extract_text()

lines = text.splitlines()

# Basic game information
game_date = re.search(r"Date:\s*(.+)", text).group(1).strip()

site = re.search(r"Site:\s*(.+)", text).group(1).strip()
site = re.sub(r",\s*", ", ", site)

stadium = re.search(r"Stadium:\s*(.+)", text).group(1).strip()
attendance = int(re.search(r"Attendance:\s*(\d+)", text).group(1))
kickoff = re.search(r"Kickoff time:\s*(.+)", text).group(1).strip()

# Opponent and location
home_match = re.search(r"^(.+?) vs Arkansas \(", text, re.MULTILINE)
away_match = re.search(r"^Arkansas vs (.+?) \(", text, re.MULTILINE)

if home_match:
    opponent = home_match.group(1)
    location_type = "HOME"
elif away_match:
    opponent = away_match.group(1)
    location_type = "AWAY"
else:
    raise ValueError("Could not find opponent")

# Scores
arkansas_score = None
opponent_score = None

for line in lines:
    if line.startswith("Arkansas "):
        parts = line.split()

        if len(parts) == 6:
            arkansas_score = int(parts[-1])

    if line.startswith(opponent + " "):
        numbers = [part for part in line.split() if part.isdigit()]

        if len(numbers) == 5:
            opponent_score = int(numbers[-1])

# Clean fields
game_date = datetime.strptime(game_date, "%b %d, %Y")
kickoff = datetime.strptime(kickoff, "%I:%M %p")

result = "W" if arkansas_score > opponent_score else "L"

game = {
    "season": game_date.year,
    "game_date": game_date.strftime("%Y-%m-%d"),
    "opponent": opponent,
    "location_type": location_type,
    "arkansas_score": arkansas_score,
    "opponent_score": opponent_score,
    "result": result,
    "site": site,
    "stadium": stadium,
    "attendance": attendance,
    "kickoff_time": kickoff.strftime("%H:%M"),
    "source_url": pdf_url,
}

print(game)
