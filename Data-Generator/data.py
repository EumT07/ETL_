import random, logging, os, time
from datetime import datetime, timedelta
import pandas as pd
from typing import List, Dict, Tuple
from source_details import countries, product_catalog, order_status, payment_methods, ads_sources
from unidecode import unidecode

class FakeDataGenerator:
    def __init__(self, max_size: int = 100, customer_size: int = 40, products_size: int = 100, orders_size: int = 200):
        self.max_size = max_size
        self.customer_size = customer_size
        self.products_size = products_size
        self.orders_size = orders_size
        self._setup_logger()
        self.logger.info("Starting FakeDataGenerator with max_size=%s", self.max_size)
        self.customers, self.products, self.orders = self._fake_dataset()
        self.df = pd.DataFrame()

    def _setup_logger(self) -> None:
        self.logger = logging.getLogger("FakeDataGenerator")
        if not self.logger.handlers:
            self.logger.info("Creating Log Folder")
            time.sleep(2)
            folder = "./log"
            os.makedirs(folder, exist_ok=True)
            time.sleep(2)
            handler = logging.FileHandler("./log/fakedatagenerator.log", encoding="utf-8")
            formatter = logging.Formatter(
                "%(asctime)s %(levelname)s [%(name)s] %(message)s",
                datefmt="%Y-%m-%d %H:%M:%S",
            )
            handler.setFormatter(formatter)
            self.logger.addHandler(handler)
        self.logger.setLevel(logging.INFO)
        self.logger.propagate = False

    def _fake_dataset(self) -> Tuple[List[Dict], List[Dict], List[Dict]]:
        try:
            self.logger.info("Starting fake dataset generation")
            time.sleep(2)
            customers = self.generate_customers(self.customer_size)
            time.sleep(2)
            products = self.generate_products(self.products_size)
            time.sleep(2)
            orders = self.generate_orders(self.orders_size)
            self.logger.info("Finished fake dataset generation")
            return customers, products, orders
        except Exception:
            self.logger.exception("Error generating fake dataset")
            raise

    def generate_customers(self, customer_size) -> List[Dict]:
        try:
            self.logger.info("Starting customer generation")
            # Messing Data
            spaces = ["  ", "", " ", "   "]
            characters = ["_","-","/"]
            customer_type = ["cst","customer","user"]
            customer_pool = []
            for _ in range(customer_size):
                # Generating a pool of unique customers to choose from later
                by_country = random.choice(countries)
                # Get ads
                ads_from = random.choice(ads_sources)
                #Gender to create user 
                gender = random.choice(["female","male"])
                first_name = f"{random.choice(spaces)}{random.choice(by_country['people'][gender]['first_name'])}{random.choice(spaces)}"
                last_name = f"{random.choice(spaces)}{random.choice(by_country['last_names'])}{random.choice(spaces)}"
                
                customer_pool.append({
                    "id": f"{random.choice(customer_type)}{random.choice(characters)}{random.randint(0000, 9999)}",
                    "first_name":first_name,
                    "last_name": last_name,
                    "email": self._fake_email(first_name.strip(),last_name.strip()),
                    "gender": random.choice(by_country['people'][gender]['gender']),
                    "birth_date": self._fake_random_dates(1980,2008),
                    "address": self._fake_address(by_country["city"],by_country["state"],by_country["street"]),
                    "country": random.choice(by_country['country']),
                    "reviews": random.randint(0,5),
                    "ads_source": random.choice(ads_from['ads'])
                })
            self.logger.info("Finished customer generation")
            return customer_pool
        except Exception:
            self.logger.exception("Error generating customers")
            raise

    def generate_products(self, products_size) -> List[Dict]:
        try:
            self.logger.info("Starting product generation")
            product_pool = []
            characters = ["_","-","/"]
            letters = ["T","A","O","I","R","Z","U"]
    
            for _ in range(products_size):
                price, quantity, total = self._products_price()
                letter_code = f"{random.choice(letters)}{random.choice(letters)}"
                product = random.choice(product_catalog)
                products = random.choice(product['product_details'])
                product_pool.append({
                    "id": f"PRO{random.choice(characters)}{random.randint(0000,9999)}-{letter_code}{random.randint(00,99)}",
                    "category": product['category'],
                    "sub_category": product["subcategory"],
                    "product_brand": random.choice(products['brand_variants']),
                    "product_name": random.choice(products['products']),
                    "price": price,
                    "quantity": quantity,
                    "total": total
                })
            self.logger.info("Finished product generation")
            return product_pool
        except Exception:
            self.logger.exception("Error generating products")
            raise

    def generate_orders(self, orders_size) -> List[Dict]:
        try:
            self.logger.info("Starting order generation")
            characters = ["_","-","/"]
            letters = ["T","A","O","I","R","Z","U"]
            orders = []
            for _ in range(orders_size):
                purchase_date, shipping_date, delivery_date = self._generate_orderDates()
                letter_code = f"{random.choice(letters)}{random.choice(letters)}"
                orders.append({
                    "transaction_id": f"TXN{random.choice(characters)}{random.randint(10000, 99999)}-{letter_code}",
                    "purchase_date": purchase_date,
                    "order_status": random.choice(order_status),
                    "payment_method": random.choice(payment_methods),
                    "shipping_date": shipping_date,
                    "delivery_date": delivery_date
                })
            self.logger.info("Finished order generation")
            return orders
        except Exception:
            self.logger.exception("Error generating orders")
            raise

    def _fake_email(self,first_name,last_name) -> str:
        try:
            domains = ["gmail.com", "yahoo.com", "hotmail.com", "outlook.com", "icloud.com", "protonmail.com","mail.com","org.com","ormail.com"]
            characters = ["_",".",""]
            numbers = [x for x in range(0,100)]
            email = f"{unidecode(first_name)}{random.choice(characters)}{unidecode(last_name)}{random.choice(numbers)}@{random.choice(domains)}"
            return email.lower()
        except Exception:
            self.logger.exception("Error generating fake email")
            raise

    def _fake_address(self,city,state,street) -> str:
        try:
            character = ["zt","ave","th","AA","hh"]
            number = random.randint(0,40)
            city = random.choice(city)
            street = random.choice(street)
            state = random.choice(state)
            zip_code = random.randint(1000,99999)
            return f"{street} {number} {random.choice(character)}, {city} {zip_code} st {unidecode(state)}"
        except Exception:
            self.logger.exception("Error generating fake address")
            raise
    
    def _fake_random_dates(self,start_year:int, end_year:int)-> str:
        try:
            start_date = datetime(start_year,1,1)
            end_date = datetime(end_year,12,1)
            _dates = (end_date - start_date).days
            random_days = random.randint(0, _dates)
            random_date = start_date + timedelta(days=random_days)
            day = random_date.strftime("%Y-%m-%d")
            return day
        except Exception:
            self.logger.exception("Error generating fake dates")
            raise
    
    def _products_price(self) -> tuple:
        try:
            price = None
            quantity = None
            total = None

            p = round(random.uniform(10.0, 3000.0), 4)
            q = random.randint(1, 10)
            t = round(p * q, 4)

            null_option = random.choice([0,1,2])

            if null_option == 0:
                
                price = f"${p}" if random.choice([True, False]) else p
                quantity = q
                total = f"${t}" if random.choice([True, False]) else t
            
            if null_option == 1:
                price = None
                quantity = q
                total = t
            
            if null_option == 2:
                price = f"${p}" if random.choice([True, False]) else p
                quantity = None
                total = f"${t}" if random.choice([True, False]) else t

            return price, quantity, total
        except Exception:
            self.logger.exception("Error generating product price data")
            raise

    def _generate_orderDates(self):
        try:
            purchase_date = self._fake_random_dates(2018,2026)
            shipping_date = None
            delivery_date = None

            #Days to deliver the product
            days = random.choice([0,1,2])

            if days == 0:
                #Shipping and delivery the same purchase day
                shipping_date = purchase_date
                delivery_days = random.randint(1,2)
                delivery_date = datetime.strptime(shipping_date, "%Y-%m-%d").date() + timedelta(days=delivery_days)

            if days == 1:
                #2 to 4 days
                shipping_days = random.randint(3,5)
                shipping_date = datetime.strptime(purchase_date, "%Y-%m-%d").date() + timedelta(days=shipping_days)
                delivery_days = random.randint(3,5)
                delivery_date = shipping_date + timedelta(days=delivery_days)

            if days == 2:
                #4 to 6 days
                shipping_days = random.randint(6,8)
                shipping_date = datetime.strptime(purchase_date, "%Y-%m-%d").date() + timedelta(days=shipping_days)
                delivery_days = random.randint(7,12)
                delivery_date = shipping_date + timedelta(days=delivery_days)

            return purchase_date, shipping_date, delivery_date
        except Exception:
            self.logger.exception("Error generating order dates")
            raise

    def generate(self) -> pd.DataFrame:
        try:
            self.logger.info("Starting DataFrame generation")
            order_rows = []
            # Loops to build the denormalized dataset rows
            for i in range(self.max_size):
                order_rows.append(self._generate_sample_order())
            
            # High-performance alternative to df.append()
            self.df = pd.DataFrame(order_rows)

            #Creating Folder and file path
            self.logger.info("Creating Source Folder")
            time.sleep(2)
            folder = "./source"
            file_name = "crm_data"
            os.makedirs(folder, exist_ok=True)
            csv_root = os.path.join(f"{folder}/{file_name}.csv")
            excel_root = os.path.join(f"{folder}/{file_name}.xlsx")

            #Creating csv and excel files
            self.logger.info("Creating CSV and Excel Files")
            time.sleep(2)
            self.df.to_excel(excel_root, engine='openpyxl', index=False, sheet_name="CRM")
            self.df.to_csv(csv_root, index=False, sep=";", encoding='utf-8-sig')
            self.logger.info("Finished DataFrame generation")
            return self.df
        except Exception:
            self.logger.exception("Error generating DataFrame")
            raise

    def _generate_sample_order(self) -> Dict:
        try:
            characters = ["_","-"]
            abc = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
            word = random.choice(abc) + random.choice(abc) + random.choice(abc)
            customer = random.choice(self.customers)
            product = random.choice(self.products)
            orders = random.choice(self.orders)
            
            # Build denormalized messy layout
            return {
                "_id": f"ASTT{random.choice(characters)}{word}{random.randint(100000, 999999)}{random.choice(characters)}{random.randint(00,99)}",
                "cst_id": customer['id'],
                "cst_first_name": customer['first_name'],
                "cst_last_name": customer['last_name'],
                "cst_birth_day": customer['birth_date'],
                "cst_email": customer['email'],
                "cst_address": customer['address'],
                "cst_gender": customer['gender'],
                "cst_country": customer['country'],
                "cst_reviews": customer['reviews'],
                "cst_ads_source": customer['ads_source'],
                "pro_id": product["id"],
                "pro_name": product["product_name"],
                "pro_brand": product["product_brand"],
                "pro_category": product["category"],
                "pro_sub_category": product["sub_category"],
                "pro_unit_price": product['price'],
                "pro_quantity": product['quantity'],
                "pro_total": product['total'],
                "or_id": orders['transaction_id'],
                "or_status": orders['order_status'],
                "or_payment_method": orders['payment_method'],
                "or_purchase_date": orders['purchase_date'],
                "or_shipping_date": orders['shipping_date'],
                "or_delivery_date": orders['delivery_date']
            }
        except Exception:
            self.logger.exception("Error generating sample order")
            raise
