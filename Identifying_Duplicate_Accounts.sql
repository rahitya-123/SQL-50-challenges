
SELECT DISTINCT 
user_name1,user_name2 from
(select CD1.username as user_name1,CD2.username AS user_name2 from Production.CustomerDetails CD1
LEFT join Production.CustomerDetails CD2 ON CD1.last_name=CD2.last_name and CD1.date_of_birth=CD2.date_of_birth
WHERE CD1.username!=CD2.username

UNION ALL

select CD1.username as user_name1,CD2.username AS user_name2 from Production.CustomerDetails CD1
LEFT join Production.CustomerDetails CD2 ON CD1.valid_mobile_no=CD2.valid_mobile_no
WHERE CD1.username!=CD2.username

UNION ALL

select CD1.username as user_name1,CD2.username AS user_name2 from Production.CustomerDetails CD1
LEFT join Production.CustomerDetails CD2 ON CD1.last_name=CD2.last_name AND CD1.postcode_area=CD2.postcode_area
WHERE CD1.username!=CD2.username

) A;