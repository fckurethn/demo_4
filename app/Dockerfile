FROM alpine:3.5
COPY requirements.txt ./
RUN apk add --update py2-pip && \
 pip install --upgrade pip && \
 pip install requests && \
 pip install --no-cache-dir -r requirements.txt
COPY store/ /usr/src/app/

EXPOSE 5000
ENTRYPOINT ["python"]
CMD ["/usr/src/app/app.py"]
