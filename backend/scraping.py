import sys
import json
import os
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from bs4 import BeautifulSoup
import time
from transformers import BertTokenizer, BertForSequenceClassification
import torch

def setup_driver():
    chrome_options = Options()
    chrome_options.add_argument('--headless')
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-dev-shm-usage')
    
    if os.environ.get('RAILWAY_ENVIRONMENT'):
        # Production settings
        chrome_options.binary_location = '/usr/bin/google-chrome-stable'
        service = Service(executable_path='/usr/bin/chromedriver')
    else:
        # Local development
        service = Service(ChromeDriverManager().install())
    
    return webdriver.Chrome(service=service, options=chrome_options)

# Fungsi untuk prediksi sentimen
def predict_sentiment(text, tokenizer, model, device, max_len=512):
    encoded_text = tokenizer(
        text,
        max_length=max_len,
        padding='max_length',
        truncation=True,
        return_tensors='pt'
    )
    input_ids = encoded_text['input_ids'].to(device)
    attention_mask = encoded_text['attention_mask'].to(device)
    
    with torch.no_grad():
        outputs = model(input_ids, attention_mask=attention_mask)
    
    logits = outputs.logits
    return 1 if torch.argmax(logits, dim=1).item() == 1 else 0

def main():
    if len(sys.argv) < 2:
        print(json.dumps({"error": "No URL provided"}))
        return

    imdb_url = sys.argv[1]

    try:
        # Load model - ensure model files are in ./model directory
        tokenizer = BertTokenizer.from_pretrained('./model')
        model = BertForSequenceClassification.from_pretrained('./model')
        device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        model = model.to(device)
        model.eval()

        # Setup browser
        driver = setup_driver()
        driver.get(imdb_url)
        time.sleep(3)

        # Scrape reviews
        while True:
            try:
                see_more_button = WebDriverWait(driver, 5).until(
                    EC.element_to_be_clickable((By.CSS_SELECTOR, "span.ipc-see-more__text")))
                driver.execute_script("arguments[0].click();", see_more_button)
                time.sleep(2)
            except:
                break

        soup = BeautifulSoup(driver.page_source, "html.parser")
        reviews = [div.get_text(strip=True) for div in soup.find_all("div", class_="ipc-html-content-inner-div")]
        driver.quit()

        # Analisis sentimen
        positive_count = 0
        for review in reviews:
            if predict_sentiment(review, tokenizer, model, device):
                positive_count += 1

        total_reviews = len(reviews)
        positive_percent = (positive_count / total_reviews) * 100 if total_reviews > 0 else 0
        negative_percent = 100 - positive_percent

        # Output hasil
        print(json.dumps({
            "success": True,
            "result": {
                "total_reviews": total_reviews,
                "positive": round(positive_percent, 2),
                "negative": round(negative_percent, 2),
                "sample_reviews": reviews[:3]  # Include sample for debugging
            }
        }))

    except Exception as e:
        print(json.dumps({
            "success": False,
            "error": str(e),
            "message": "Analysis failed"
        }))
    finally:
        if 'driver' in locals():
            driver.quit()

if __name__ == "__main__":
    main()