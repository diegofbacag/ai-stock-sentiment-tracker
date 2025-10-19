from urllib.request import urlopen, Request
from bs4 import BeautifulSoup
from nltk.sentiment.vader import SentimentIntensityAnalyzer
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime

# La plataforma utilizada para acceder a las noticias
finviz_url = 'https://finviz.com/quote.ashx?t='
# Las acciones de IA utilizadas para este análisis
tickers = ['NVDA', 'IBM', 'MSFT', 'AMZN', 'AI']

# Accediendo y almacenando la data
news_tables = {}

for ticker in tickers:
    url = finviz_url + ticker
    
    req = Request(url=url, headers={'user-agent': 'my-app'})
    response = urlopen(req)

    html = BeautifulSoup(response, features='html.parser')
    news_table = html.find(id='news-table')
    news_tables[ticker] = news_table
    
# Extracción de información de la data
parsed_data = []
today = datetime.now().date()

for ticker, news_table in news_tables.items():
    for row in news_table.findAll('tr'):
        title = row.a.text
        date_data = row.td.text.strip().split(' ')

        if len(date_data) == 1:
            time = date_data[0]
        else:
            date = date_data[0]
            time = date_data[1]

        news_date = pd.to_datetime(date).date()

        #periodo de tiempo
        if (today - news_date).days <= 7:
            parsed_data.append([ticker, news_date, time, title])

# Análisis de Sentimiento           
df = pd.DataFrame(parsed_data, columns=['ticker', 'date', 'time', 'title'])
vader = SentimentIntensityAnalyzer()

print("Polarity scores:", vader.polarity_scores("3 AI Stocks to Avoid Right Now"))

f = lambda title: vader.polarity_scores(title)['compound']
df['compound'] = df['title'].apply(f)

# Preparando la data para su visualización
df['date'] = pd.to_datetime(df.date).dt.date
mean_df = df.groupby(['ticker', 'date']).mean(numeric_only=int).unstack()
mean_df = mean_df.xs('compound', axis='columns').transpose()
mean_df.plot(kind='bar')
plt.show()
