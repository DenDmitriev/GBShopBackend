# GBShopBackend
Backend layer for iOS shop app

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
 - all
 - add
 - get
 - delete
## Product
 - category
 - add
 - update
 - get
 - delete
## Review
 - add
 - get
 - delete
## User
 - register
 - update
 - get
 - put
 - delete

# Stack
Swift, Vapor, Fluent

# Framework
Vapor

