import os
import boto3
import torchaudio
from flask import Flask, request 
from audiocraft.models import MusicGen
from audiocraft.data.audio import audio_write
import os

app = Flask(__name__)
s3 = boto3.client("s3")

# モデルのロード（アプリケーション起動時に1回だけ実行）
model = MusicGen.get_pretrained('facebook/musicgen-melody')

# リクエストの書き方
# curl -X POST http://xxxxxxx:7860/generate_audio -H "Content-Type: application/json" -d '{"prompt": "new york house", "duration": 30}' --output generated_music.wav
@app.route('/generate_audio', methods=['POST'])
def generate_audio():
    prompt = request.json.get('prompt')

    # 音楽生成パラメータの設定
    model.set_generation_params(duration=10)

    try:
        # 音楽生成
        wav = model.generate([prompt])

        # 音声ファイルの保存
        output_dir = os.path.join(os.path.dirname(__file__), 'audio_output')
        os.makedirs(output_dir, exist_ok=True)
        output_filename = 'generated_music.wav'
        output_path = os.path.join(output_dir, output_filename)
        
        # audio_write関数の使用（拡張子を含まないファイル名を渡す）
        audio_write(os.path.splitext(output_path)[0], wav[0].cpu(), model.sample_rate, strategy="loudness", loudness_compressor=True)

        # ファイルが実際に作成されたか確認
        if not os.path.exists(output_path):
            raise FileNotFoundError(f"Failed to create file at {output_path}")

        # S3にアップロード
        bucket = ""
        key = ""
        with open(output_path, 'rb') as f:
            s3.put_object(Body=f, Bucket=bucket, Key=key)

    except Exception as e:
        # エラーログを出力
        app.logger.error(f"Error generating audio: {str(e)}")
        return str(e), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=7860)