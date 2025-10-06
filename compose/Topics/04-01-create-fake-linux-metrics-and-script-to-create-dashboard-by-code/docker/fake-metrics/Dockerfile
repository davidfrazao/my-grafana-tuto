FROM python:3.12-alpine
RUN pip install --no-cache-dir prometheus_client
COPY exporter.py /exporter.py
EXPOSE 8000
CMD ["python", "/exporter.py"]