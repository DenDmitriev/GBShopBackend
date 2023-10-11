# GBShopBackend
Backend layer for iOS shop app

# Stack
Swift, Vapor, Fluent

# Framework
Vapor

# Database
SQLite

# API

## Authorization
 - [login](#login)
 - [me](#me)
 - [logout](#logout)

### login
Authorization in customer service
To authenticate an API request, you should provide your mail and password in the `Authorization Basic` header.

```http
POST /login HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io
Authorization: Basic <Data>
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `Username` | `String` | <YOUR_MAIL> |
| `Password` | `String` | <YOUR_PASSWORD> |

Result

```json
{
    "user": {
        "email": <YOUR_MAIL>,
        "name": <YOUR_NAME>,
        "token": <YOUR_TOKEN>,
        "creditCard": <YOUR_MOCK_CARD_NUMBER>,
        "id": <YOUR_UUID>
    },
    "result": 1
}
```

### me
Authorization in customer service with token
```http
GET /me HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io
Authorization: Bearer <YOUR_TOKEN>
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `Token` | `String` | <YOUR_TOKEN> |

Result

```json
{
    "result": 1,
    "user": {
        "id": <YOUR_UUID>,
        "name": <YOUR_NAME>,
        "creditCard": <YOUR_MOCK_CARD_NUMBER>,
        "email": <YOUR_MAIL>
    }
}
```

### logout
Logout from customer service

```http
POST /logout HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io
Content-Length: 162
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW

------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="id"

<YOUR_UUID>
------WebKitFormBoundary7MA4YWxkTrZu0gW--

```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `id` | `UUID` | form-data key <YOUR_UUID> |

Result

```json
{
    "result": 1
}
```

## Basket
 - [get](#get)
 - [add](#add)
 - [delete](#delete)
 - [payment](#payment)

### get

Get customer basket

```http
GET /baskets/get?userID=<YOUR_UUID> HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `userID` | `UUID` | <YOUR_UUID> |

Result

```json
{
    "basket": {
        "userID": "03287CD8-E180-4EBF-9F3F-57D0B6153335",
        "products": [
            {
                "image": "https://cm.samokat.ru/processed/l/public/89d40eec23db5880_4601662000016.jpg",
                "name": "Молоко Parmalat",
                "id": "AFB3B70B-8C73-42DA-826B-312AC5AD4437",
                "price": {
                    "price": 127,
                    "discount": 15
                },
                "categoryID": "AFB3B70B-8C73-42DA-826B-312AC5AD4437",
                "description": "ультрапастеризованное, 3,5% 1 л"
            },
            {
                "image": "https://cm.samokat.ru/processed/l/public/8156f371aa0111f8_4635000821216-1.jpg",
                "name": "Томаты Эко-культура ",
                "id": "13D5D97C-E9AC-4A50-830E-989E66F14863",
                "price": {
                    "price": 135,
                    "discount": 10
                },
                "categoryID": "13D5D97C-E9AC-4A50-830E-989E66F14863",
                "description": "коктейльные, сливовидные, красные, на ветке 250 г"
            }
        ],
        "total": {
            "price": 229.45,
            "discount": 0
        }
    },
    "result": 1
}
```

### add

Add product from customer basket

```http
POST /baskets/add HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io
Content-Length: 381
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW

------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="userID"

<YOUR_UUID>
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="productID"

<PRODUCT_UUID>
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="count"

1
------WebKitFormBoundary7MA4YWxkTrZu0gW--
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `userID` | `UUID` | <YOUR_UUID> |
| `productID` | `UUID` | <PRODUCT_UUID> |
| `count` | `Int` | Count product |

Result

```json
{
    "result": 1,
    "userMessage": "Товар успешно добавлен в корзину."
}
```

### delete

Delete product from customer basket

```http
POST /baskets/delete HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io
Content-Length: 381
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW

------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="userID"

<YOUR_UUID>
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="productID"

<PRODUCT_UUID>
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="count"

1
------WebKitFormBoundary7MA4YWxkTrZu0gW--
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `userID` | `UUID` | <YOUR_UUID> |
| `productID` | `UUID` | <PRODUCT_UUID> |
| `count` | `Int` | Count product |

Result

```json
{
    "result": 1,
    "userMessage": "Товар успешно удален из корзины."
}
```

### payment

Payment customer basket

```http
POST /baskets/payment HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io
Content-Length: 259
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW

------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="userID"

<YOUR_UUID>
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="total"

229.45
------WebKitFormBoundary7MA4YWxkTrZu0gW--
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `userID` | `UUID` | <YOUR_UUID> |
| `total` | `Double` | Basket total price |

Result

```json
{
    "result": 1,
    "total": 229.45,
    "receipt": [
        {
            "count": 1,
            "name": "Томаты Эко-культура ",
            "price": 121.5
        },
        {
            "count": 1,
            "name": "Молоко Parmalat",
            "price": 107.95
        }
    ]
}
```

## Category
 - [all](#all)
 - [add](#add)
 - [get](#get)
 - [delete](#delete)

### all
Categories

```http
GET /categories/all HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io

```

Result

```json
[
    {
        "description": "Молочные и сырные продукты",
        "name": "Молоко, яйца и сыр",
        "id": "FADBC09E-83FB-4FF4-B3B6-C412B6CBF4CB"
    },
    {
        "description": "Мучные продукты",
        "name": "Хлеб и выпечка",
        "id": "754F21E2-563E-48B7-BA0E-EF54ABF61943"
    },
    {
        "description": "Овощи и фрукты",
        "name": "Овощи и фрукты",
        "id": "E752CC4F-D288-4082-B56A-C3CE9381D979"
    },
    ...
]
```

### add
Add new category method

```http
POST /categories/add HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io
Content-Length: 274
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW

------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="name"

Вода и напитки
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="description"

Вода, газировка, соки, морсы, чай, кофе
------WebKitFormBoundary7MA4YWxkTrZu0gW--
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `name` | `TYPE` | Name new category |
| `description` | `TYPE` | Description category |

Result

```json
{
    "result": 1,
    "category": {
        "name": "Вода и напитки",
        "id": "CF766CBE-CDEB-4DB1-AE33-E4C61460CB82",
        "description": "Вода, газировка, соки, морсы, чай, кофе"
    }
}
```

### get
Get category by id

```http
GET /categories/<CATEGORY_ID> HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io
```

Result

```json
{
    "category": {
        "id": <CATEGORY_ID>,
        "description": "Вода, газировка, соки, морсы, чай, кофе",
        "name": "Вода и напитки"
    },
    "result": 1
}
```

### delete
Delete category by id

```http
DELETE /categories/<CATEGORY_ID> HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io
```

Result

```json
1
```

## Product
 - category
 - add
 - update
 - get
 - delete
 
 ### category
Products by page from category

```http
GET /products/category?page=1&per=10&category=<CATEGORY_ID> HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `page` | `Int` | page number (start at 1) |
| `per` | `Int` | element per page |
| `category` | `UUID` | UUID of category |

Result

```json
{
    "products": [
        {
            "price": {
                "discount": 15,
                "price": 127
            },
            "description": "ультрапастеризованное, 3,5% 1 л",
            "image": "https://cm.samokat.ru/processed/l/public/89d40eec23db5880_4601662000016.jpg",
            "categoryID": "AFB3B70B-8C73-42DA-826B-312AC5AD4437",
            "id": "AFB3B70B-8C73-42DA-826B-312AC5AD4437",
            "name": "Молоко Parmalat"
        },
        {
            "price": {
                "price": 99,
                "discount": 10
            },
            "description": "пастеризованное, 2,5% 930 мл",
            "image": "https://cm.samokat.ru/processed/l/original/158334_425819778.jpg",
            "categoryID": "CD4BA35C-2F97-4A69-9337-2436B8F39D1B",
            "id": "CD4BA35C-2F97-4A69-9337-2436B8F39D1B",
            "name": "Молоко Домик в деревне "
        },
        {
            "price": {
                "price": 149,
                "discount": 15
            },
            "description": "цельного молока со сливками, 4-20% 250 г",
            "image": "https://cm.samokat.ru/processed/l/public/9379eb8487374c27_4610115200798-1.jpg",
            "categoryID": "E9E57016-E6A6-4854-86AC-2B297A661F8F",
            "id": "E9E57016-E6A6-4854-86AC-2B297A661F8F",
            "name": "Творог Самокат пластовой"
        },
        ...
    ],
    "metadata": {
        "page": 1,
        "per": 10,
        "total": 4
    },
    "page": 1,
    "result": 1
}
```

### add
Add new product method to category

```http
POST /products/add HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io
Content-Length: 736
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW

------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="name"

Яйцо шоколадное Kinder Сюрприз
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="price"

129
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="discount"

10
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="description"

Содержит игрушку
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="image"

<IMAGE_URL>
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="categoryID"

<CATEGORY_ID>
------WebKitFormBoundary7MA4YWxkTrZu0gW--
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `name` | `String` | Name of product |
| `price` | `Double` | Double type price product |
| `discount` | `Int` | Int8 Price discount |
| `description` | `String` | Description product |
| `image` | `URL` | image URL |
| `categoryID` | `UUID` | Description |

Result

```json
{
    "result": 1
}
```

### update
Update product  method

```http
POST /products/update HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io
Content-Length: 856
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW

------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="id"

<PRODUCT_ID>
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="name"

Яйцо шоколадное Kinder Сюрприз
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="price"

129
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="discount"

15
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="description"

Содержит игрушку
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="image"

<IMAGE_URL>
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="categoryID"

<CATEGORY_ID>
------WebKitFormBoundary7MA4YWxkTrZu0gW--

```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `id` | `UUID` | UUID of product |
| `name` | `String` | Name of product |
| `price` | `Double` | Double type price product |
| `discount` | `Int` | Int8 Price discount |
| `description` | `String` | Description product |
| `image` | `URL` | image URL |
| `categoryID` | `UUID` | Description |

Result

```json
{
    "result": 1
}
```

### get
Product by id

```http
GET /products/<PRODUCT_ID> HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io
```

Result

```json
{
    "product": {
        "image": "https://cm.samokat.ru/processed/l/public/68730c54bcf00481_40084107-1.jpg",
        "description": "Содержит игрушку",
        "category": {
            "id": <PRODUCT_ID>
        },
        "price": 129,
        "name": "Яйцо шоколадное Kinder Сюрприз",
        "id": <CATEGORY_ID>,
        "discount": 15
    },
    "result": 1
}
```

### delete
Delete product by id

```http
DELETE /products/<PRODUCT_ID> HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io
```

Result

```json
1
```
 
## Review
 - add
 - get
 - delete
 
### add
Add review method

```http
POST /reviews/add HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io
Content-Length: 515
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW

------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="userID"

<USER_ID>
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="productID"

<PRODUCT_ID>
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="review"

Коллекционирую игрушки из Киндера уже 20 лет.
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="rating"

4
------WebKitFormBoundary7MA4YWxkTrZu0gW--
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `userID` | `UUID` | UUID customer |
| `productID` | `UUID` | UUID of product |
| `review` | `String` | String with number of characters from 0 to 280 |
| `rating` | `Int` | Int with value from 1 to 5 |

Result

```json
{
    "result": 1
}
```

### get
Get review method

```http
GET /reviews/get?productID=<PRODUCT_ID>&page=1&per=10 HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `productID` | `UUID` | UUID of product |
| `page` | `Int` | Int page numbers start at 1 |
| `per` | `Int` | Int element per page |

Result

```json
{
    "metadata": {
        "per": 10,
        "page": 1,
        "total": 1
    },
    "reviews": [
        {
            "createdAt": "2023-10-11T12:15:09Z",
            "review": "Коллекционирую игрушки из Киндера уже 20 лет.",
            "rating": 4,
            "productID": <PRODUCT_ID>,
            "id": <REVIEW_ID>,
            "reviewer": "Денис"
        }
    ],
    "result": 1
}
```

### delete
Delete review method

```http
DELETE /reviews/<REVIEW_ID> HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io```

Result

```json
1
```
## User
 - register
 - update
 - get
 - put
 - delete

### register
Registration new user method

```http
POST /users/register HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io
Content-Length: 543
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW

------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="name"

GitHub
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="password"

secret12
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="confirmPassword"

secret12
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="email"

git@git.hub
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="creditCard"

<CREDIT_CARD_NUMBER>
------WebKitFormBoundary7MA4YWxkTrZu0gW--
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `name` | `String` | Name of user |
| `password` | `String` | Password of user |
| `confirmPassword` | `String` | Confirm password of user |
| `email` | `String` | Email of user |
| `creditCard` | `String` | Number credit card of user |

Result

```json
{
    "result": 1,
    "userID": <USER_ID>,
    "userMessage": "Регистрация GitHub прошла успешно!"
}
```

### update
Update user data method

```http
POST /users/update HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io
Content-Length: 660
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW

------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="id"

<USER_ID>
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="name"

Cat
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="password"

secret12
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="confirmPassword"

secret12
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="email"

git@git.hub
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="creditCard"

1234123412341234
------WebKitFormBoundary7MA4YWxkTrZu0gW--

```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `id` | `UUID` | UUID user for find in database. This value can't update |
| `name` | `String` | Name of user |
| `password` | `String` | Password of user |
| `confirmPassword` | `String` | Confirm password of user |
| `email` | `String` | Email of user |
| `creditCard` | `String` | Number credit card of user |

Result

```json
{
    "user": {
        "email": "git@git.hub",
        "name": "Cat",
        "creditCard": "1234123412341234",
        "passwordHash": <PASSWORD_HASH>,
        "id": <USER_ID>
    },
    "result": 1
}
```

### get
Get user method by id

```http
GET /users/<USER_ID> HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io
```

Result

```json
{
    "passwordHash": <PASSWORD_HASH>,
    "name": "Cat",
    "id": <USER_ID>,
    "creditCard": "1234123412341234",
    "email": "git@git.hub"
}
```

### delete
Delete user func by id

```http
DELETE /users/<USER_ID> HTTP/1.1
Host: gbshopbe-denisdmitriev.amvera.io
```

Result

```json
1
```
