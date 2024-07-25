FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime

RUN apt update && \
    apt install -y --no-install-recommends git ffmpeg && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/facebookresearch/audiocraft.git .
RUN pip install -e .

EXPOSE 7860
ENTRYPOINT ["python3"]
CMD ["demos/magnet_app.py", "--listen", "0.0.0.0"]

