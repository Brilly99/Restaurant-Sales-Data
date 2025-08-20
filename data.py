import csv
import random
from faker import Faker
from datetime import datetime, timedelta

fake = Faker("id_ID")

# Jumlah data
N_CUSTOMERS = 200
N_MANAGERS = 20
N_PRODUCTS = 100
N_SALES = 500
N_PAYMENT_METHODS = 4

# -----------------------------
# 1. Customers
# -----------------------------
with open("customers.csv", "w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["customer_id", "name", "city"])
    for i in range(1, N_CUSTOMERS+1):
        writer.writerow([i, fake.name(), fake.city()])

# -----------------------------
# 2. Managers
# -----------------------------
with open("managers.csv", "w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["manager_id", "name", "department"])
    departments = ["Sales", "IT", "Finance", "HR", "Marketing"]
    for i in range(1, N_MANAGERS+1):
        writer.writerow([i, fake.name(), random.choice(departments)])


# -----------------------------
# 3. Products
# -----------------------------
with open("products.csv", "w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["product_id", "product_name", "category", "price"])
    
    categories = ["Elektronik", "Fashion", "Makanan", "Minuman", "Olahraga", "Kesehatan", "Rumah Tangga"]
    
    for i in range(1, N_PRODUCTS+1):
        product_name = fake.word().capitalize()
        category = random.choice(categories)
        
        # Harga realistis dalam Rupiah (kelipatan 500 atau 1000)
        base_price = random.randint(5000, 200000)
        price = round(base_price / 500) * 500  # dibulatkan ke kelipatan 500
        
        writer.writerow([i, product_name, category, price])

# -----------------------------
# 4. Payment Methods
# -----------------------------
payment_methods = ["Cash", "Credit Card", "E-Wallet", "Bank Transfer"]
with open("payment_methods.csv", "w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["payment_id", "method"])
    for i, pm in enumerate(payment_methods, start=1):
        writer.writerow([i, pm])

# -----------------------------
# 5. Sales
# -----------------------------
with open("sales.csv", "w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["order_id", "customer_id", "manager_id", "payment_id", "date"])
    for i in range(1, N_SALES+1):
        date = fake.date_between(start_date="-1y", end_date="today")
        writer.writerow([
            i,
            random.randint(1, N_CUSTOMERS),
            random.randint(1, N_MANAGERS),
            random.randint(1, N_PAYMENT_METHODS),
            date
        ])

# -----------------------------
# 6. Order Items
# -----------------------------
with open("order_items.csv", "w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["order_id", "product_id", "quantity"])
    for order_id in range(1, N_SALES+1):
        n_items = random.randint(1, 5)  # tiap order bisa ada 1–5 produk
        product_ids = random.sample(range(1, N_PRODUCTS+1), n_items)
        for pid in product_ids:
            writer.writerow([order_id, pid, random.randint(1, 10)])
