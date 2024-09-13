/* 
Bank's Comprehensive Lending Data Exploration

Skills used: Windows Functions, Aggregate Functions, Converting Data Types
*/

-- DASHBOARD 1

-- REVIEW THE DATA AFTER IMPORTING 

SELECT *
FROM bank_loan;

-- TOTAL NUMBER OF LOANS

SELECT COUNT(id) AS Total_Loan_Apps
FROM bank_loan;

-- MONTH TO DATE LOAN APPLICATIONS

SELECT COUNT(id) AS MTD_Total_Loan_Apps
FROM bank_loan
WHERE MONTH(issue_date) = 12;

-- MOM (MONTH ON MONTH) APPLICATION

SELECT COUNT(id) AS PMTD_Total_Loan_Applications
FROM bank_loan
WHERE MONTH(issue_date) = 11;

-- TOTAL FUNDED AMOUNT

SELECT SUM(loan_amount) AS Total_Funded_Amount
FROM bank_loan;

-- MTD (MONTH-TO-DATE) FUNDED AMOUNT

SELECT SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM bank_loan
WHERE MONTH (issue_date) = 12;	

-- PMTO (PREVIOUS MONTH-TO-DATE FUNDED AMOUNT

SELECT SUM(loan_amount) AS Total_Funded_Amount
FROM bank_loan
WHERE MONTH (issue_date) = 11;

-- TOTAL RECIEVED AMOUNT FROM THE BANK'S CUSTOMERS

SELECT SUM(total_payment) AS Total_Amount_Recieved
FROM bank_loan;

-- MTD TOTAL RECIEVED AMOUNT FROM THE BANK'S CUSTOMERS


SELECT SUM(total_payment) AS MTD_Total_Amount_Recieved
FROM bank_loan
WHERE MONTH(issue_date) = 12;

-- PMTD TOTAL RECIEVED AMOUNT FROM THE BANK'S CUSTOMERS

SELECT SUM(total_payment) AS PMTD_Total_Amount_Recieved
FROM bank_loan
WHERE MONTH(issue_date) = 11;

-- AVERAGE INTEREST RATE ROUNDED TO 2 DECIMAL PLACES

SELECT ROUND((AVG(int_rate) * 100), 2) AS AVG_Interest_Rate
FROM bank_loan;

-- MTD AVERAGE INTEREST RATE ROUNDED TO 2 DECIMAL PLACES

SELECT ROUND((AVG(int_rate) * 100), 2) AS MTD_AVG_Interest_Rate
FROM bank_loan
WHERE MONTH(issue_date) = 12;

-- PMTD AVERAGE INTEREST RATE ROUNDED TO 2 DECIMAL PLACES

SELECT ROUND((AVG(int_rate) * 100), 2) AS PMTD_AVG_Interest_Rate
FROM bank_loan
WHERE MONTH(issue_date) = 11;

-- AVERAGE DEBT-TO-INCOME RATION (DTI)

SELECT ROUND((AVG(dti)*100), 2) AS AVG_DTI
FROM bank_loan;

-- MTD AVERAGE DEBT-TO-INCOME RATION (DTI)

SELECT ROUND((AVG(dti)*100), 2) AS MTD_AVG_DTI
FROM bank_loan
WHERE MONTH (issue_date) = 12;

-- PMTD AVERAGE DEBT-TO-INCOME RATION (DTI)

SELECT ROUND((AVG(dti)*100), 2) AS PMTD_AVG_DTI
FROM bank_loan
WHERE MONTH (issue_date) = 11;

-- GOOD LOAN PERCENTAGE OF APPS

SELECT 
	(COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100)
	/
	COUNT(id) AS Good_loan_Percent
FROM bank_loan;

-- NUMBER OF GOOD LOAN APPS

SELECT COUNT(id) AS Num_Good_Loan
FROM bank_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- GOOD LOAN FUNDED AMOUNT

SELECT SUM(loan_amount) AS good_loan_funded_amont
FROM bank_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- GOOD LOAN RECEIVED AMOUNT

SELECT SUM(total_payment) AS good_loan_received_amount
FROM bank_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- BAD LOAN PERCENTAGE OF APPS

SELECT 
	(COUNT(CASE WHEN loan_status = 'Charged off' THEN id END) * 100)
	/
	COUNT(id) AS Bad_loan_Percent
FROM bank_loan;

-- NUMBER OF BAD LOAN APPS

SELECT COUNT(id) AS Num_Bad_Loan
FROM bank_loan
WHERE loan_status = 'Charged off'

-- BAD LOAN FUNDED AMOUNT

SELECT SUM(loan_amount) AS Bad_loan_funded_amont
FROM bank_loan
WHERE loan_status = 'Charged off';

-- GOOD LOAN RECEIVED AMOUNT

SELECT SUM(total_payment) AS Bad_loan_received_amount
FROM bank_loan
WHERE loan_status = 'Charged off';

-- LOAN STATUS FOR GRID VIEW

SELECT
	loan_status,
	COUNT(id) AS Total_Loan_Apps,
	SUM(total_payment) AS Total_Payment_Received,
	SUM(loan_amount) AS Total_Funded_Amount,
	ROUND(AVG(int_rate * 100), 2) AS Interest_Rate,
	ROUND(AVG(dti * 100), 2) AS DTI
FROM bank_loan
GROUP BY loan_status;

-- MTD AMOUNT FUNDED AND MTD AMOUNT RECIEVED

SELECT
	loan_status,
	SUM(total_payment) AS MTD_Total_Payment_Received,
	SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM bank_loan
WHERE MONTH(issue_date) = 12
GROUP BY loan_status;

-- DASHBOARD 2 -- OVERVIEW --

-- MONTHLY TRENDS BY ISSUE DATE

SELECT 
	MONTH(issue_date) AS Month_Num,
	DATENAME(MONTH, issue_date) AS Month,
	COUNT(id) AS Total_Loan_Apps,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Recieved_Amount
FROM bank_loan
GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date)
ORDER BY MONTH(issue_date);

-- REGIONAL ANALYSIS BY STATE

SELECT 
	address_state AS State,
	COUNT(id) AS Total_Loan_Apps,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Recieved_Amount
FROM bank_loan
GROUP BY address_state
ORDER BY COUNT(id) DESC;

-- LOAN TERM ANALYSIS

SELECT 
	term AS term,
	COUNT(id) AS Total_Loan_Apps,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Recieved_Amount
FROM bank_loan
GROUP BY term
ORDER BY term DESC;

-- EMPLOYEE LENGTH ANALYSIS

SELECT 
	emp_length AS Emp_Length,
	COUNT(id) AS Total_Loan_Apps,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Recieved_Amount
FROM bank_loan
GROUP BY emp_length
ORDER BY COUNT(id) DESC;

-- PURPOSE FOR LOAN

SELECT 
	purpose AS Purpose,
	COUNT(id) AS Total_Loan_Apps,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Recieved_Amount
FROM bank_loan
GROUP BY purpose
ORDER BY COUNT(id) DESC;

-- APPS BY HOME OWNERSHIP STATUS

SELECT 
	home_ownership AS Home_Ownership,
	COUNT(id) AS Total_Loan_Apps,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Recieved_Amount
FROM bank_loan
GROUP BY home_ownership
ORDER BY COUNT(id) DESC;
