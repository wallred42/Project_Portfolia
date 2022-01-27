# CSV Spliter

# TO DO
  # 1) DONE! YAY!! Add headers to each csv file
    # Add if then to check for the exitence of a header
  # 2) Split it by Client[0], Carrier[19], ContactEmail[5]
    #- repeat the split loop and change to criteria for each and put the results into different folders
    #-put the sliter into a function
      #Run the main() once, then put the following mail()'s into a 
      # Second round() that loops through the data variable
  # 3) Cleaner(): Figure out a way to process an error notifications when there are
    # files that don't have contact info, Contact Jake!!
    # Maybe, run a test before splitting the file to make 
      # sure that every row in column f is filled
      # Maybe, with the function just fill the blanks w/ 'This was blank'
      # or 'there was no contact info provided for these rows'
    # In addition, make sure none of the emails have characters that can't
    # be saved in file names: namely, \/:*?"<>| and then remove them

import csv,os
from os import listdir
from datetime import date
from pathlib import Path


#print('What is the username on your computer account?')
username = 'William' #input()

#print('What is the file name?')
FileName = '9fdc20c8-b086-44d3-88fd-38326e5c3163' #input()

# Test questions
  # if I redefine 'FileName' in the function will the new value be input the second time the function is called
    # Or, should I write another fucntion to redefine 'FileName' outside of the spliter()

# Data Extraction
OriginPath = "C:\\Users\\" + username + "\\Downloads\\" + FileName + ".csv"

def readCSV(path):
  file = open(path,newline='') 
  reader = csv.reader(file)
  global header, data
  header = next(reader) # Marks the first line as the header
  data = [row for row in reader] # reads the rest of the file

#readCSV(OriginPath)

# Data Cleaning
  # COMING SOON!!! 
  # Cleans and ORGANIZE IT IN ASCENDING ORDER
def cleaner(toclean,index):
  global data
  data = sorted(toclean, key=lambda x: x[index])
  #print(data[0])

# Data Destiniation
today = date.today().strftime("%d%b%Y") # Makes the folder w/ today's date 07Jul2020

def folder_maker(name):
  global JungleDiskFilePath
  JungleDiskFilePath = "L:\\Carrier Notifications\\" + today + "\\" + name
  Path(JungleDiskFilePath).mkdir(parents=True,exist_ok=True)

#folder_maker('Contact')
 
# defines the function that writes the files
def file_writer(Row1,Dataset_Row2,AddText): #add a third param to pouvoir add test to the name afterwards
  NewFilePath = JungleDiskFilePath + "\\" + str(data[Row1][Column]) + AddText + ".csv" # New File location
  NewFile = open(NewFilePath,'a',newline='')
  writer = csv.writer(NewFile)
  writer.writerow(Dataset_Row2)
  #print(NewFilePath)

# The loop divides up the data into different csv's

NewFileDelimiter = [0] # Stores the indexs that mark the start of a new file

def spliter(new_name):
  """This splits the the info in the data variable into different csv files
    based on the column number entered in the main function."""
  RowCount = len(list(data)) # Counts the rows in the Carrier Notifications CSV
  row = 0
  
  while row <= (RowCount-2): # This is the last iterable integer of row; in english: "while row is less than or equal to the end of the file..."
    if row == 0:
        file_writer(row,header,new_name)
    if data[row][Column] == data[(row+1)][Column]: # Compares a cell with the same cell on the next row
      
      file_writer(row,data[row],new_name)
      #print('worked on ' + str(row))
    else:
      file_writer(row,data[row],new_name)
      NewFileDelimiter.append((row+1)) # Added the new file delimiter to the list
      file_writer((row+1),header,new_name)
      #print(NewFileDelimiter)
      #print('failed on ' + str(row))
    row += 1

  LastRow = (RowCount-1)

  # writes the LastRow in the appropriate file 
  if data[LastRow][Column] == data[(RowCount-2)][Column]:
    file_writer(row,data[LastRow],new_name)
  else:
    file_writer(LastRow,data[LastRow],new_name)



def main(filetosplit,groupby,col,new_name):
  """This combines all of the functions."""
  global Column
  Column = col # COLUMN Number (A=0); change depending on where the emails are in file stucture
  readCSV(filetosplit)
  cleaner(data,col)
  folder_maker(groupby)
  spliter(new_name)

# First main function; group by Client
main(OriginPath,'Client',0,'')

def repeat(OriginGroup,groupby,col):
  """ This makes the main function iterable."""
  destination = "L:\\Carrier Notifications\\" + today + "\\" + OriginGroup + "\\"
  dir = listdir(destination)
  for file in dir:
    NewFileTag = (", " + os.path.splitext(file)[0])
    #print((destination+file))
    main((destination+file),groupby,col,NewFileTag)


#repeat('Client','Carrier',19) 
  # Clients that only have one row in the origin file
  # are put into files wihtout the header on the first repeat
  # So, they prolly don't show up in the final result.
#repeat('Carrier','Contact',5)
# Here is the list of weird things that are happening
  # 1)the header row is missing on most, not every, single line file in the Carrier folder
  # 2) the Contact interation throws a index out of range and a stopiteration exception SOMETIMES NOT ALL THE TIME JUST SOMETIMES
  # 3) The Contact stops in random places when it running



# destiniation = "L:\\Carrier Notifications\\" + today + "\\" + 'Carrier' + "\\"
# dir = listdir(destiniation)

# for file in dir:
#   NewFileTag = (", " + os.path.splitext(file)[0])
#   main((destiniation+file),'Contact',5,NewFileTag) 
#   print(file)
# main(...,pass,'Contact',5)
# figure our renaming thigy 3

# for emails in #data[Column]
#   main(emails,pass,'Client')
