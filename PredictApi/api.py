from fastapi import FastAPI, Form
from fastapi.middleware.cors import CORSMiddleware
from keras.models import load_model
import numpy as np
from PIL import Image
from io import BytesIO
import base64

# Carregar o modelo treinado
model = load_model("best_model.keras")

# Iniciar a aplicação FastAPI
app = FastAPI()

# Permitir CORS de todas as origens
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],       # Permite todas as origens
    allow_credentials=True,
    allow_methods=["*"],       # Permite todos os métodos HTTP
    allow_headers=["*"],       # Permite todos os cabeçalhos
)

# Função para processar a imagem e fazer a previsão
def preprocess_image(img):
    # Redimensiona a imagem para o tamanho esperado pelo modelo
    img = img.resize((224, 224))  # Ajuste conforme o tamanho do seu modelo
    img_array = np.array(img)
    img_array = np.expand_dims(img_array, axis=0)  # Adiciona a dimensão do batch
    img_array = img_array / 255.0  # Normaliza a imagem (se necessário)
    return img_array

@app.get("/")
async def get():
    return {"message": "Ok"}

# Agora o endpoint espera um campo de formulário "imagem" do tipo string (base64)
@app.post("/classificar")
async def classificar(imagem: str = Form(...)):
    try:
        # Decodifica o base64 recebido
        img_bytes = base64.b64decode(imagem)
        img = Image.open(BytesIO(img_bytes))

        # Pré-processamento da imagem
        img_array = preprocess_image(img)

        # Fazer a previsão
        previsao = model.predict(img_array)
        classe_predita = int(np.argmax(previsao, axis=1)[0])
        
        return {
            "classe": int(classe_predita)
        }       
    except Exception as e:
        return {"erro": str(e)}
