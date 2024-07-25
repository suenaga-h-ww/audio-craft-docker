FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata && \
    apt-get install -y --no-install-recommends git ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/facebookresearch/audiocraft.git .
# アプリケーションコードをコピー
COPY . .
RUN pip install flask boto3
RUN pip install -e .

EXPOSE 7860
CMD ["python3", "app.py"]

