from flask import Flask, render_template
import random
import requests
app = Flask(__name__)

images = [
"https://pbs.twimg.com/profile_images/1285384386771394560/1kSxAdMB_400x400.jpg",
"https://i.pinimg.com/474x/b4/f1/f1/b4f1f19330a0542e69f1ea8c92ced4fc.jpg",
"https://img-07.stickers.cloud/packs/6971e3d5-efe4-4893-9938-aa9c5b5174fc/webp/6dd14ce6-87fe-40c6-baf7-fed843db5e11.webp",
"https://64.media.tumblr.com/1b00fab3be8bee554173e51f570c064b/tumblr_otyc3wq9FK1w7964eo1_500.jpg",
"https://stickerly.pstatic.net/sticker_pack/V3UsPH6pEtk8qTcLjMqdQ/F4MF00/33/f09686fb-1d57-4571-bac1-c27eed034321.png",
"https://lh3.googleusercontent.com/4ethcI-9Xyhd7yXxDthP3AfRcgQu-FkrAspVivZUrt_6IBOtaBWJwB530xyzJNyO1wI"]
@app.route('/')
def index():
  url = random.choice(images)
  res = requests.get('http://169.254.169.254/latest/meta-data/local-ipv4')
  ip = res.text
  return render_template('index.html', url=url, ip=ip)
if __name__ == "__main__":
 app.run(host = "0.0.0.0")
