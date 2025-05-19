# DataAnalytics-Assessment

This repository contains SQL scripts used for analyzing user behavior, transactions, and customer value across a financial dataset. The goal was to demonstrate practical data analytics skills through data cleaning, transformation, and metric calculations.

## My Experience
This was my **first real SQL assessment** — and I won’t lie, when I first looked at the schema, I was **totally overwhelmed**. Each of the 4 tables had a massive number of parameters:
- `plans` table: **56 columns**
- `savings`: **37 columns**
- `user`: **57 columns**
- `withdrawal`: **23 columns**

At first, I didn’t even know where to start. But here’s where my *"never give up"* mindset (perks of being an analyst 😤) kicked in. I realized before jumping into any solution, I had to **observe** the structure, **understand each column**, and most importantly — **clean the dataset properly**.

I used my usual strategy: pen and paper 📝. I noted down every important field, assumption, and step. Then I went through the questions and the hints in the assessment doc carefully.

## Data Cleaning Approach

Before writing any solution, I **cleaned each table separately** using a *soft filtering* technique. I added an `is_deleted` flag:
- `0` → Keep this row
- `1` → Flagged as invalid

(Yeah, I know direct filtering would be clearer, but I was still figuring it out.)

That’s why, along with the 4 SQL assessment files, you’ll also find **4 more SQL files** — one for **data cleaning for each table** — and this `README.md`.

### Cleaning Logic Summary

####  Plans Table
- Removed duplicate IDs
- Checked nulls in foreign keys
- Removed future or null start dates
- Detected invalid plans with 0 or negative amounts (used logic based on `is_fund`)
- Standardized Boolean values
- Identified test data & donation rule violations
- Validated date logic
- Currency flags check was skipped (needed more context)

####  User Table
- Checked nulls in critical fields
- Detected future join/birth dates
- Removed test/dummy users
- Flagged fraud-risk users
- Removed users with invalid geo-coordinates
- Checked for inactive accounts

####  Savings Table
- Nulls in key fields
- Invalid/future transaction or maturity dates
- Suspicious or negative records
- Less aggressive filtering due to **heavy data loss**
- Invalid/missing fees
- Currency validation and invalid return dates

####  Withdrawal Table
- Nulls in key fields
- Negative withdrawn amounts
- Invalid transaction dates
- Broken business logic
- Dummy/test data
- Invalid fees, currency, and transaction status

> The **savings table** was honestly the most error-ridden one. It took the most time and made me rethink how I define “clean.”

##  Per-Question Explanations

### **Q1: Data Cleaning**
- Cleaned all four tables using custom logic.
- Flagged invalid records using `is_deleted`.

### **Q2: Frequency Segmentation**
- Grouped monthly savings transactions.
- Calculated average frequency per user.
- Segmented users into High, Medium, Low frequency.

### **Q3: Inactive Plans**
- Found savings/investment plans.
- Joined with latest transaction date.
- Marked plans as inactive if no activity for 12+ months.

### **Q4: Customer Lifetime Value (CLV)**
- Calculated tenure in months.
- Estimated monthly contribution.
- Used formula:
  > CLV = (Monthly Transactions × 12) × Avg Profit Per Transaction

##  Challenges & How I Solved Them

###  1. Large Schema Size
- At first I didn’t know what to focus on. But breaking the problem into smaller chunks helped.

###  2. Cleaning the Savings Table
- Lots of broken/messy data.
- Took a *less aggressive* approach to avoid losing important info.

###  3. Choosing Soft Filtering
- I used `is_deleted` flags instead of direct filtering. It's not ideal for readability, but it helped me keep track.

###  4. Learning Curve on Financial Data
- This was my first time working with such a dataset.
- Used ChatGPT + Google to understand terms, but eventually had to trust my own instincts and observations.

##  Tech Stack

- SQL (MySQL-compatible syntax)
- GitHub for version control
- Pen and paper 

##  Author

**Avik Sarkhel**  
 MCA Student |  Aspiring Data Analyst  
 Based in Kolkata, India  
 Learning by doing, always.

##  Final Words
Thanks to this assessment, I’ve discovered new weak spots and learned how to power through complexity. I now understand the **real-world challenge of cleaning messy datasets** and how much of an impact it has on accurate analysis.  
This was not just an assignment — it was a **level-up moment** in my analytics journey.
