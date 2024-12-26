# Project Name: **Bite@UI**  

[![Build status](https://build.appcenter.ms/v0.1/apps/3c2b2ff8-9307-4bc3-8bee-140ca3c2e1ac/branches/main/badge)](https://appcenter.ms)

### Deployment Link

[https://install.appcenter.ms/orgs/biteatui/apps/biteatui/distribution_groups/public/releases/7](https://install.appcenter.ms/orgs/biteatui/apps/biteatui/distribution_groups/public/releases/7)

### Table of Contents  
- [Group Members](#group-members)  
- [Application Description](#bookmark_tabs-application-description)  
- [Modules and Work Division](#memo-modules-and-work-division) 
- [Roles/Actors](#busts_in_silhouette-rolesactors)  
- [Integration with Web Service](#integration-with-web-service)  

---

## Group Members  
| Name                         | Role/Contribution              | GitHub Username  |  NPM | 
|------------------------------|--------------------------------|------------------|------|  
| Andriyo Averill Fahrezi      | Deployment CI/CD, Creating Landing Page, Create Reviews, Create Faculty (Canteen) Page, Create Add Faculty and Add Canteen, Helping the Admin/User Compatibility         | @muzkii          | 2306172325   | 
| Aleksey Panfilov             |            | @ankou-k                |  2406394370 |
| Catherine Aurellia           | Created the Figma for Faculty (Canteen) Page, Stall Page and Favorites Page, Help implement the Front End for Favorites Page, Edit the Left Drawer UI and managed Left Drawer routing to all pages            | @neaurellia                |  2306256261 |
| Chiara Aqmarina Diankusumo   |                    | @caqqmarina                |  2306171480 |
| Kusuma Ratih Hanindyani      |                 | @ksmratih                |  2306256406 |
| Rayienda Hasmaradana Najlamahsa | Implemented the Logout Feature, Edited the Left Drawer          | @rayienda               |  2306172735 |

---

## :bookmark_tabs: Application Description  
**Name**: **UI Canteen Finder AKA BITE@UI**  
**Purpose**: This application is designed to provide users with recommendations and information for UI canteens based on their food preferences or faculty. It helps users quickly find canteens that align with their tastes, menus, or locations. The app is tailored for students, office workers, and visitors looking for efficient dining options within the UI campus.  

---

## :memo: Modules and Work Division  
### Modules Implemented _FLUTTER_
1. **CRD Faculty**: Implement adding,  viewing, and deleting faculties.  
    - Developed by:  Andriyo Averill Fahrezi
2. **CRD Canteen**: Manage canteen information.  
    - Developed by: Andriyo Averill Fahrezi
3. **CRD Stall**: Add, update, and remove stall information within canteens.  
    - Developed by:  
4. **CRD Product**: Maintain product details within stalls.  
    - Developed by:  
5. **Homepage**: Create the homepage to display canteen summaries.  
    - Developed by:   Chiara Aqmarina Diankusumo
6. **Login and Register**: Authentication for user and admin accounts.  
    - Developed by: Kusuma Ratih Hanindyani w/ Andriyo Averill Fahrezi   
7. **CRD Reviews**: Enable customers to write and view stall reviews.  
    - Developed by: Andriyo Averill Fahrezi  
8. **Search Bar, Navbar, and Filters**: Enhance navigation and content filtering.  
    - Developed by:   Chiara Aqmarina Diankusumo w/ Catherine Aurellia
9. **Favorite Foods**: Allow users to save their favorite food.
    - Developed by:   Chiara Aqmarina Diankusumo
  
### Modules Implemented _DJANGO_
1. **CR Flutter Login**: Create a new login inside `views.py` to hamdle Flutter logins
    - Developed by: Kusuma Ratih Hanindyani
2. **CR Flutter Register**: Create a new register inside `views.py` to handle Fluter registers
    - Developed by: Kusuma Ratih Hanindyani
3. **RU Flutter Logout**: Create a new logout inside `views.py` to handle Flutter logouts
    - Developed by: Rayienda Hasmaradana Najlamahsa 
5. **CRD Flutter Faculty**: Implement adding and deleting Faculty for the Flutter project
    - Developed by: Andriyo Averill Fahrezi
6. **CRD Flutter Canteen**: Implement adding and deleting Canteen for the Flutter project
    - Developed by: Andriyo Averill Fahrezi
7. **CRD Flutter Stall**: Implement adding and deleting Stall for the Flutter project
    - Developed by: Chiara Aqmarina Diankusumo
8. **CRD Flutter Product**: Implement adding and deleting Product for the Flutter project
    - Developed by:
9. **CRD Flutter Reviews**: Implement adding and deleting Review for the Flutter project
    - Developed by: Andriyo Averill Fahrezi
10. Update the models of our Django Project such that it can be integrated with the Flutter project
    - Developed by: All members

---

## :busts_in_silhouette: Roles/Actors  
1. **Customer**  
    - View canteen stalls, browse menus, search, and filter options.  
    - Write and read reviews for stalls.
    - Add their own favorite products to the favorite products page
2. **Admin/Merchant**  
    - Modify website content, including faculties, canteens, stalls, products, and reviews.  
    - Access and manage all canteen stalls and administrative settings.  

---

## Integration with Web Service  
This application integrates with the web service created during the first semester project deployed to the PWS website. Step-by-step:

1. Using `django-cors-headers`, `pbp_django_auth` package, and `provider` package.
2. Create a new application to handle authentication for the Flutter project, implement all the `views.py` and `urls.py` for the given application.
3. Fetch the JSON data using [Quicktype](http://app.quicktype.io/) website and create a respective entry accordingly
4. Create new CRUD function inside `views.py` of our `main` application for the Flutter project on our Django Midterm Project.

### Features Enabled by Integration:  
- **Seamless Data Sync**: Data for faculties, canteens, stalls, and products are synchronized between the backend API and the Flutter web app.  
- **Scalability**: The integration is designed to allow modular additions for future functionalities, such as analytics or real-time updates.
- **On The Go**: Real time updates both the web and mobile version for the same account user

--- 
