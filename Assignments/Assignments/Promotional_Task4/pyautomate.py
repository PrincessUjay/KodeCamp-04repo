import os
import subprocess

base_directory = "/vagrant"
company_directory = "KodeCamp_Stores"

# Define users and their groups
users = {
    "Andrew": "System_Administrator",
    "Julius": "Legal",
    "Chizi": "Human_Resource_Manager",
    "Jeniffer": "Sales_Manager",
    "Adeola": "Business_Strategist",
    "Bach": "CEO",
    "Gozie": "IT_intern",
    "Ogochukwu": "Finance_Manager"
}

command = ["sudo", "useradd", "-m", "-G"] # Legal Julius 

# fun // function
def create_user(username, group):
    """Create a user and assign them to a group."""
    try:
        subprocess.run(['sudo', 'useradd', '-m', '-G', group, username], check=True)
        print(
            f"User {username} created successfully and added to group {group}")
    except subprocess.CalledProcessError as e:
        print(f"User {username} not created: {e}")
     
def create_group(groupname):
    """Create group"""
    try:
        subprocess.run(['sudo', 'groupadd', groupname], check=True)
        print(
            f"group '{groupname}' created successfully")
    except subprocess.CalledProcessError as e:
        print(f"group '{groupname} creation failed'. Error: {e.stderr}")
    except Exception as e:
        print(f"An unexpected error occurred: {str(e)}")

# List of company directories
company_directories = {
    "Finance Budgets": "Finance_Manager",
    "Contract Documents": "Legal",
    "Business Projections": "Business_Strategist",
    "Business Models": "Sales_Manager",
    "Employee Data": "Human_Resource_Manager",
    "Company Vision and Mission Statement": "CEO",
    "Server Configuration Script": "System_Administrator""IT_intern"
}

def check_dir():
    """Check if a directory exists"""
    dirs = os.listdir("./")
    # print(f"dirs in check_dir(): {dirs}")
    # print(f"dir in dirs: {dir}")
    if company_directory in dirs:
        exist = "Directory exists"
    else:
        exist = "Directory does not exist"
    return exist

#To get the current working directory
cwd = os.getcwd()

#create directory
def create_directory(directoryname):
    if cwd == base_directory:
        directory_exist = check_dir()
        #print(f"directory exist value: {directory_exist}")
        if directory_exist == "Directory does not exist":
            try:
                os.mkdir(f"{company_directory}/")
                create_directories(directoryname)
                print(
                    f"Directory /{company_directory}/{directoryname} created"
                )
            except OSError as e:
                print(f"Error creating directory: {e}")
        else:
                create_directories(directoryname)
    else:
        os.chdir(base_directory)
        os.mkdir(f"{company_directory}/")
        create_directories(directoryname)
        print(f"Directory/{company_directory}/{directoryname} created")

def create_directories(directoryname):
    """Create company directories."""
    try:
        os.makedirs(f"/{company_directory}/{directoryname}", exist_ok=True)
        print(f"Directory/{company_directory}/{directoryname} created")
    except OSError as e:
        print(
            f"Error creating directory /{company_directory}/{directoryname}: {e}")
        
#Setting Permissions
def set_permissions(directoryname, username, group):
    try:
        subprocess.run(["sudo","chown", f"{username}:{group}",
                        f"/{company_directory}/{directoryname}"], check=True)
        subprocess.run(
            ["sudo", "chmod", "770", f"/{company_directory}/{directoryname}"], check=True)
        print(f"Permissions set for /{company_directory}/{directoryname}")
    except subprocess.CalledProcessError as e:
        print(
            f"Error setting permissions for /{company_directory}/{directoryname}: {e}")

def create_file():
    """Create a file in a specified directory."""
    filename = input("Enter the name of the file: ")
    directoryname = input("Enter the directory to create the file in: ")
     
    if directoryname in company_directories:
        file_path = f"/{company_directory}/{directoryname}/{filename}"
        try:
            with open(file_path, "w") as file:
                file.write("This is a new file.\n")
            print(
                f"File {filename} created in /{company_directory}/{directoryname}")
        except IOError as e:
            print(f"Error creating file {filename}: {e}")
    else:
        print(
            f"Directory /{company_directory}/{directoryname} does not exist. File not created.")

def main():
    # Create Users and Directories
    for username, group in users.items():
        create_group(group)
        create_user(username, group)

    for directory_name, group in company_directories.items():
        create_directory(directory_name)

        user = [username for username,
                    usr_group in users.items() if usr_group == group]
        if user:
            set_permissions(directory_name, user[0], group)

    create_file()

#define main function
main()

