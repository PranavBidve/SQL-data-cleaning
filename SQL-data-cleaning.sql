-- Viewing data

select * 
from housing


-- Converting date format

select SaleDate, cast(saleDate as date)
from housing

select SaleDate, convert(date, saleDate, 101)
from housing

--101 - mm/dd/yyyy
--102 - yy.mm.dd
--103 - dd/mm/yyyy
--104 - dd.mm.yyyy
--105 - dd-mm-yyyy

-- CONVERT as option style paramter, CAST does not have it

alter table housing
add SaleDateConverted date

update housing 
set SaleDateConverted = convert(date, SaleDate)


-- Property Address segregation 

select propertyAddress
from housing
where propertyAddress is null

select propertyAddress
from housing

select substring(propertyAddress, 1, charindex(',', propertyAddress)-1),
       substring(propertyAddress, charindex(',', propertyAddress)+1, len(propertyAddress))
from housing

alter table housing
add house varchar(255)

update housing
set house = substring(propertyAddress, 1, charindex(',', propertyAddress)-1)

alter table housing
add state varchar(255)

update housing
set state = substring(propertyAddress, charindex(',', propertyAddress)+1, len(propertyAddress))

select * 
from housing

sp_rename 'housing.state', 'city'

select ownerAddress
from housing

select 
parsename(replace(ownerAddress, ',', '.'), 3),
parsename(replace(ownerAddress, ',', '.'), 2),
parsename(replace(ownerAddress, ',', '.'), 1)
from housing

alter table housing
add ownerHouse varchar(255)

update housing
set ownerHouse = parsename(replace(ownerAddress, ',', '.'), 3)

alter table housing
add ownerCity varchar(255)

update housing
set ownerCity = parsename(replace(ownerAddress, ',', '.'), 2)

alter table housing
add ownerState varchar(255)

update housing
set ownerState = parsename(replace(ownerAddress, ',', '.'), 1)

select *
from housing


-------

-- Changing soldAsVacant

select soldAsVacant, count(soldAsVacant)
from housing
group by soldAsVacant


select
case when soldAsVacant = 'Y' THEN 'Yes'
     when soldAsVacant = 'N' THEN 'No'
	 else soldAsVacant
	 end
from housing

update housing 
set SoldAsVacant = case when soldAsVacant = 'Y' THEN 'Yes'
     when soldAsVacant = 'N' THEN 'No'
	 else soldAsVacant
	 end

-- Delete duplicates

with CTE_duplicate as(
select *,
	row_number() over (
	partition by ParcelID, 
			     PropertyAddress, 
				 SalePrice, 
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID) row_num
from housing
)
select *
from CTE_duplicate
where row_num>1

select * 
from housing

-- Deleting unused columns

alter table housing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table housing
drop column SaleDate

