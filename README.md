
# Loyalty Tier App

A monorepo project that combines a Rails backend with a Vue.js frontend using Vite. The entire application can be run locally or using Docker.

This app provide service of Loyalty program with Bronze/Silver/Gold tiers.

![Image of list customers demo](https://i.ibb.co/RgTCqJp/Customers.png)
![Image of list orders demo](https://i.ibb.co/xqGgqn2/Orders.png)

## Run Locally

#### Pre-requisites:

- Ruby 3.2.2
- Rails 7.1.1
- Node.js 20.9.0
- PostgreSQL 14.9

#### Clone the project
```bash
git clone https://github.com/gammarinaldi/loyalty-tier.git
```

```bash
cd loyalty-tier
```

### Setup backend (Rails)

#### Go to the backend directory
```bash
cd api
```

#### Create .env file
```bash
cp env.example .env
```

#### Install dependencies
```bash
bundle
```

#### Setup database and data seed
```bash
rails db:prepare
```

#### Tier adjustment in customers data
```bash
rails tier:recalculate
```
#### Run the application
```bash
rails s
```

#### Access the application
```bash
http://localhost:4000
```

#### Running Test with Rspec

To run test, run the following command in `api` directory:

```bash
rspec
```
Output
```bash
Coverage report generated for RSpec to /loyalty/api/coverage. 380 / 395 LOC (96.2%) covered.
```

#### Cron Job with Rake Task
Recalculate the current tier of each customer at the end of each year

- In terminal open: `crontab -e`
- Input `59 23 31 12 * /loyalty/api/bin/rake tier:recalculate RAILS_ENV=production`
- This cron job runs the `tier:recalculate` task at the end of every year.

### Setup frontend (Vue+Vite)

#### Go to the backend directory
```bash
cd client
```

#### Create .env file
```bash
cp env.example .env
```

#### Install dependencies
```bash
npm install
```

#### Run the application
```bash
npm run dev -- --port 3000
```

#### Access the application
```bash
http://localhost:3000
```

## Run with Docker
#### Pre-requisites:
- Docker 4.24.1

#### Create .env file in project directory root
```bash
cp env.example .env
```

#### Run the application
```bash
docker compose up
```
Docker will do:
- Create 3 containers (api, client, and database)
- Install all dependencies
- Setup database
- Seed data
- Run rake task
- Run backend, frontend, and PostgreSQL

    
## API Reference
### Authorizaiton

All request require headers authorization 
| Headers | Type     | Value                |
| :-------- | :------- | :------------------------- |
| `Authorizaiton` | `JWT` | `Bearer abc123`|

### Get all customers
```http
  GET /api/v1/customers
```

#### Response Body
```json
{
    "status": "Success",
    "data": [
        {
            "customerId": "d4d1d658-5d04-412b-949d-1a70aa4c17d7",
            "customerName": "Alane Sanford",
            "tier": "Silver"
        },
        {
            "customerId": "aab345e7-0d77-4b99-aae4-f2e89db309e0",
            "customerName": "Carita Williamson",
            "tier": "Silver"
        }
    ],
    "metadata": {
        "totalItems": 30,
        "totalPages": 6,
        "currentPage": 1
    }
}
```


### Get customer detail

```http
  GET /api/v1/customers/:id
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | Customer ID |

#### Response Body
```json
{
  "status": "Success",
  "data": {
    "currentTier": "Bronze",
    "startDateTierCalculation": "2022-04-06",
    "amountSpentSinceStartDate": 9034,
    "amountToNextTier": 966,
    "nextYearDowngradeTier": null,
    "downgrateDate": "2023-12-31",
    "amountToMaintainTier": 0
  }
}
```

### Create completed order

```http
  POST /api/v1/completed_orders
```
#### Request Body
```json
{
    "customerId": "61c6a62c-b3f5-4475-9bde-942e50778f3a",
    "orderId": "{{orderId}}",
    "totalInCents": 100,
    "date": "2023-11-04T00:00:00.000Z"
}
```

#### Response Body
```json
{
    "status": "Success",
    "data": {
        "orderId": "07030ee4-e7b3-49fc-bf9e-3a993806d62b",
        "totalInCents": 100,
        "date": "2023-11-04T00:00:00.000Z",
        "customerName": "Elwood Schultz"
    }
}
```
### Get all orders
```http
  GET /api/v1/orders
```

#### Response Body
```json
{
    "status": "Success",
    "data": [
        {
            "customerId": "f1d35090-d12b-458f-937b-04ab3a486230",
            "customerName": "Elwood Schultz",
            "orderId": "10f14925-78a0-4ebb-b844-7139c29bdff8",
            "date": "2022-01-01",
            "totalInCents": 9941
        },
        {
            "customerId": "87ca19d7-de10-4c45-a669-f122a06cd116",
            "customerName": "Pedro Gibson",
            "orderId": "1ef375be-1922-4bdd-8ea7-d13b59b8095c",
            "date": "2022-01-05",
            "totalInCents": 4826
        }
    ],
    "metadata": {
        "totalItems": 151,
        "totalPages": 16,
        "currentPage": 1
    }
}
```