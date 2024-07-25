FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata && \
    apt-get install -y --no-install-recommends git ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /audiocraft

RUN git clone https://github.com/facebookresearch/audiocraft.git .

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir setuptools wheel flask boto3 && \
    pip install git+https://git@github.com/facebookresearch/audiocraft

    # アプリケーションコードをコピー
COPY app.py .

EXPOSE 7860
CMD ["python3", "app.py"]

