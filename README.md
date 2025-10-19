# 🧾 AI Stock Sentiment Tracker

A data-driven analysis of stock market sentiment using financial news and NLP.

This project analyzes sentiment in news headlines for major AI-related companies, collected from [Finviz](https://finviz.com/).  
It uses Python and the VADER Sentiment Analyzer to quantify how positive or negative the market tone is for each company over a selected period.

---

## 🧩 Overview

The goal is to explore how public sentiment around AI companies evolves through time and how it might correlate with market performance.  
This project focuses on a 7-day period (July 11–19, 2023), analyzing five companies featured in *The Motley Fool’s* “Top AI Stocks to Buy in 2023” list:

- NVIDIA (`NVDA`)
- IBM (`IBM`)
- Microsoft (`MSFT`)
- Amazon (`AMZN`)
- C3.ai (`AI`)

The code can easily be adapted to analyze different stocks or timeframes.

---

## ⚙️ How It Works

1. **Data Collection**  
   Scrapes recent news headlines for selected tickers from Finviz.

2. **Data Extraction & Structuring**  
   Parses company tickers, dates, times, and titles into a structured Pandas DataFrame.

3. **Sentiment Analysis**  
   Uses the **VADER** model to compute sentiment scores for each headline (positive, neutral, negative, and compound).

4. **Aggregation & Visualization**  
   Groups results by company and date, computes average sentiment scores, and visualizes them with Matplotlib.

---

## 🧠 Tech Stack

- **Language:** Python  
- **Libraries:** `BeautifulSoup`, `NLTK (VADER)`, `pandas`, `matplotlib`  
- **Data Source:** [Finviz.com](https://finviz.com/)  

---

## 📊 Results

Across the analyzed period:
- Sentiment around **NVIDIA, IBM, and Microsoft** remained mostly positive.  
- **C3.ai** showed consistent negative sentiment in headlines.  
- **Amazon** presented positive news but a drop in its stock price, suggesting sentiment doesn’t always align with performance.

This reinforces that while sentiment can provide context, it’s not a sole indicator of market movement.

![AI Stock Sentiment Bar Graph](https://diegofbacag.github.io/images/p0bargraph.png)

---

## 🚀 Future Work

- Extend analysis to longer time periods or different sectors.  
- Correlate sentiment scores with actual stock price data.  
- Build a **dashboard or API** to track sentiment trends over time.

---

## 📝 Learn More

Read the full breakdown and analysis here:  
https://diegofbacag.github.io/mainproject.html
