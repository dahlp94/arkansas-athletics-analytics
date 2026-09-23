from datetime import datetime
from pathlib import Path
import re
import pdfplumber

PDF_PATH = Path("data/raw/2025_01_alabama_am.pdf")

with pdfplumber.open(PDF_PATH) as pdf:
    text = pdf.pages[0].extract_text()

lines = text.splitlines()

# Basic game information
game_date = re.search(r"Date:\s*(.+)", text).group(1).strip()
site = re.search(r"Site:\s*(.+)", text).group(1).strip()
stadium = re.search(r"Stadium:\s*(.+)", text).group(1).strip()
attendance = int(re.search(r"Attendance:\s*(\d+)", text).group(1))
kickoff = re.search(r"Kickoff time:\s*(.+)", text).group(1).strip()

# Opponent
opponent = re.search(r"^(.+?) vs Arkansas \(", text, re.MULTILINE).group(1)

# Scores
arkansas_score = None
opponent_score = None

for line in lines:
    if line.startswith("Arkansas "):
        parts = line.split()
        if len(parts) == 6:
            arkansas_score = int(parts[-1])

    if line.startswith(opponent + " "):
        parts = line.split()
        numbers = [part for part in parts if part.isdigit()]
        if len(numbers) == 5:
            opponent_score = int(numbers[-1])

# Clean date and kickoff time
game_date = datetime.strptime(game_date, "%b %d, %Y")
kickoff = datetime.strptime(kickoff, "%I:%M %p")

# Result
result = "W" if arkansas_score > opponent_score else "L"

game = {
    "season": game_date.year,
    "game_date": game_date.strftime("%Y-%m-%d"),
    "opponent": opponent,
    "location_type": "HOME",
    "arkansas_score": arkansas_score,
    "opponent_score": opponent_score,
    "result": result,
    "site": site,
    "stadium": stadium,
    "attendance": attendance,
    "kickoff_time": kickoff.strftime("%H:%M"),
}

print(game)
