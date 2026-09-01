import configparser
import http.client
import json
import http
from pathlib import Path


def get_air_quality_color(air_quality):
    match air_quality:
        case 1:
            return "#00e400"
        case 2:
            return "#ffff00"
        case 3:
            return "#ff7e00"
        case 4:
            return "#ff0000"
        case 5:
            return "#8f3f97"
        case _:
            return ""


CONDITION_ICONS = {
    "Clear": "󰖙",
    "Clouds": "󰖐",
    "Drizzle": "",
    "Mist": "",
    "Fog": "󰖑",
    "Haze": "󰼰",
    "Rain": "󰖗",
    "Smoke": "",
    "Dust": "",
    "Sand": "",
    "Snow": "",
    "Thunderstorm": "",
    "Tornado": "",
}

config = configparser.ConfigParser()
config_path = Path(__file__).parent / 'config.ini'
config.read(config_path)

lat = "37.8476"
lon = "-83.8592"
key = config["weather"]["OPENWEATHER_API_KEY"]

host = "api.openweathermap.org"


text = ""
class_name = ""

connection = http.client.HTTPSConnection(
    host
)

connection.request(
    "GET", f"/data/2.5/weather?lat={lat}&lon={lon}&units=imperial&appid={key}", headers={
        "Accept": "application/json"
    })

cond_res = connection.getresponse()

if not cond_res.status == 200:
    print("No Weather Data")
    exit()

weather_data = json.loads(cond_res.read())

condition = weather_data["weather"][0]["main"]
weather_icon = CONDITION_ICONS.get(condition, "")
temp = round(float(weather_data["main"]["temp"]))


connection.request("GET", f"/data/2.5/air_pollution?lat={lat}&lon={lon}&appid={key}", headers={
    "Accept": "application/json"
})
air_quality = ""
air_qual_res = connection.getresponse()
air_quality_color = ""

if air_qual_res.status == 200:
    air_quality_data = json.loads(air_qual_res.read())
    air_quality = air_quality_data["list"][0]["main"]["aqi"]
    air_quality_color = get_air_quality_color(air_quality)

text = f"{weather_icon} {condition} | {temp} 󰔅 | <span color='{air_quality_color}'>󰵃 {air_quality}</span>"
data = {
    "text": text,
    "class": class_name
}

json_string = json.dumps(data)
print(json_string)
