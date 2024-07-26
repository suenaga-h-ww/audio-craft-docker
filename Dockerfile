FROM --platform=linux/amd64 pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata && \
    apt-get install -y --no-install-recommends git ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /audiocraft

RUN git clone https://github.com/facebookresearch/audiocraft.git .

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir flask boto3 setuptools wheel && \
    pip install -e .

    # アプリケーションコードをコピー
COPY app.py .

EXPOSE 7860
CMD ["python3", "demos/magnet_app.py"]