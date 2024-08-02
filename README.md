audio craft docker project

# use
1. docker build
```
docker build -t audiocraft .
docker run -p 7860:7860 audiocraft
```

status check
```
docker ps
```

1. docker compose
```
docker compose- up -d
```

1. http request

Download audio file into local.
```
curl -X POST http://localhost:7860/generate_audio \
-H "Content-Type: application/json" \
-d '{"prompt": "lo-fi hiphop for study", "duration": 30}' \
--output output.wav
```