/*
ACTIVE-RANK [ Google SQL Interview Question]

Find the email activity rank for each user. Email activity rank is defined by the total number of emails sent. 
The user with the highest number of emails sent will have a rank of 1, and so on. Output the user, total emails, and their 
activity rank. 
Order records by the total emails in descending order. Sort users with the same number of emails in alphabetical order.
In your rankings, return a unique value (i.e., a unique rank) even if multiple users have the same number of emails. 
For tie breaker use alphabetical order of the user usernames.

Table: google_gmail_emails

google_gmail_emails Preview
id: int
from_user: varchar
to_user: varchar
day: int

*/
SELECT from_user
	, count(to_user) AS total_emails
	, row_number() OVER (
		ORDER BY count(to_user) DESC
			, from_user ASC
		) AS row_number
FROM google_gmail_emails
GROUP BY from_user;