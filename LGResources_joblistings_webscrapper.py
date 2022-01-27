# LGResources webscrapper for job listings to panda df for analysis

import requests, pandas as pd, time, re
from random import randrange
from bs4 import BeautifulSoup
#from selenium import webdriver
#mechanicalsoup, 

#TODO 
    # DONE Extract data and import into dataframe
    # IN_PROGRESS Alter URL to include all the records
    # Create mssql database
    # Automate trigger



start_time = time.time()
base_url = 'https://jobboard.tempworks.com'
url_query = '/LGResources/Jobs/Search?Keywords=&Location=&Distance=FiveHundred&SortBy=Date'
url = base_url + url_query
page = requests.get(url)
time.sleep(5)
soup = BeautifulSoup(page.content,"html.parser")


job_listings = soup.find("a", class_="text jobtitle")['href']
df = pd.DataFrame(columns=("OrderNumber","Title","Location","Order_Type"))
links = []
links.append(str(job_listings))
#print(links)



# while links[0] != None:
#     for i in range(3):
#         i = i + 1
#         if i > 3:
#             links = None
#             print(i)
#             print("worked")
            


#for i in range(5):
while links[0] != None:
    #break
    #for i in range(2):    
    # Extract data
    details_url = base_url + links[0]
    details_page = requests.get(details_url)
    details_soup = BeautifulSoup(details_page.content, "html.parser")
    
    order_number = details_soup.find("div", class_="orderId").find("span", class_="text").text.replace("Order: ","")
    title = details_soup.find("span", class_="text jobtitle").text
    location = details_soup.find("p",class_="location").find("em", class_="text").text
    order_type = details_soup.label.find_next_sibling().text                                                                     
    
    #wage = details_soup.find_all("span", style="font-weight:bold;")[0].text
    #pattern = "\d+.\d+" # Alt: find $ symbol and numbers after that
    #wage = re.search(pattern,wage).group(0)
    #print(wage)


    description1 = details_soup.find_all("em", class_="text")
    description = details_soup.find_all("span")#find_all("div",class_="text")
    #print(description)
    # for desc in description:
    #     break
    #     print(str(desc) + " \n")

    # Load data into df
    columns = list(df)
    data = []
    values = [order_number,title,location,order_type]
    zipped = zip(columns,values)
    dict1 = dict(zipped)
    #print(title + ' ' + location)
    #print(dict)
    data.append(dict1)
    df = df.append(data,True)

    #break
    ran_number = randrange(10,20)

    new_link = details_soup.strong.parent
    new_link = new_link['href']
    links = []
    links.append(new_link)
    
    timeout = time.time() + 30   # 5 minutes from now
    test = 0
    #print(test)
    if test == 5 or time.time() > timeout:
        #print('broken')
        break
    test = test - 1
    #print(test)

    time.sleep(ran_number)


    #break

#print(links)
print(df)

print("The run time was: ",time.time() - start_time, " seconds.")

#description = details_soup.find_all("p")
#for tag in description:
    #print(tag)
    #pass




# GRAVEYARD

# for link in links[0]:
#     details_url = base_url + link
#     details = requests.get(details_url)
#     time.sleep(10)

#print(BeautifulSoup(page.content,"html.parser"))
#time.sleep(10)
#     print(details)
    #print(BeautifulSoup(page.content,"html.content"))


# OLD extracted urls for joblistings on main page
# REPLACED extract next url from listing page
# links = []
# for jl in job_listings:
#     if jl.text:
#         links.append(jl['href'])

