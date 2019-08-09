SELECT "advisors"."id", 
       "advisors"."name", 
       "profilePic",
		"primaryAddresses"."city", 
       "primaryAddresses"."zipCode", 
       "primaryAddresses"."state", 
       "primaryAddresses"."primary", 
       "firmProducts"."nProducts", 
       "firms"."mission", 
       "primaryAddresses"."country", 
		"geoAdd"."distance"
FROM   "advisors" 
INNER JOIN "users" 
	   ON "users"."id" = "advisors"."userId" 
INNER JOIN (SELECT "id", 
				  "city", 
				  "primary", 
				  "state", 
				  "advisorId", 
				  "zipCode", 
				  "country" 
		   FROM   "addresses" 
		   WHERE  "primary" = true) AS "primaryAddresses" 
	   ON "primaryAddresses"."advisorId" = "advisors"."id" 
INNER JOIN "firms" 
	   ON "firms"."advisorId" = "advisors"."id" 
INNER JOIN (SELECT DISTINCT Count("id")         AS "nProducts", 
						   "products"."firmId" AS "productFirmId", 
						   "products"."firmId" 
		   FROM   "products" 
		   GROUP  BY "products"."firmId") AS "firmProducts" 
	   ON "firmProducts"."productFirmId" = "firms"."id" 
INNER JOIN "firmSizeTypes" 
	   ON "firmSizeTypes"."id" = "firms"."firmSizeId" 
INNER JOIN "valuesAlignedInvestingInfos" 
	   ON "valuesAlignedInvestingInfos"."advisorId" = "advisors"."id" 
INNER JOIN (SELECT DISTINCT Count("id")                      AS 
						   "nVotings", 
						   "proxyVotings"."investingInfoId" AS 
	  "proxyInvestingInfoId", 
						   "proxyVotings"."investingInfoId" 
		   FROM   "proxyVotings" 
		   GROUP  BY "proxyVotings"."investingInfoId") AS "votings" 
	   ON "votings"."proxyInvestingInfoId" = 
		  "valuesAlignedInvestingInfos"."id" 
INNER JOIN "teamInfos" 
	   ON "teamInfos"."advisorId" = "advisors"."id" 
INNER JOIN (SELECT DISTINCT Count("id")                 AS 
						   "nassetClasses", 
						   "assetClasses"."teamInfoId" AS 
	  "assetClasses_teamAssets", 
						   "assetClasses"."teamInfoId" 
		   FROM   "assetClasses" 
		   GROUP  BY "assetClasses"."teamInfoId") AS "teamAssets" 
	   ON "teamAssets"."assetClasses_teamAssets" = "teamInfos"."id" 
INNER JOIN (SELECT DISTINCT Count("id")                 AS 
						   "nimpactThemes", 
						   "impactThemes"."teamInfoId" AS 
	  "impactThemes_teamImpacts", 
						   "impactThemes"."teamInfoId" 
		   FROM   "impactThemes" 
		   GROUP  BY "impactThemes"."teamInfoId") AS "teamImpacts" 
	   ON "teamImpacts"."teamInfoId" = "teamInfos"."id" 
INNER JOIN (SELECT DISTINCT Count("id")                     AS 
						   "nadvisorOfferings", 
						   "advisorOfferings"."teamInfoId" AS 
				 "advisorOfferings_teamOfferings", 
						   "advisorOfferings"."teamInfoId" 
		   FROM   "advisorOfferings" 
		   GROUP  BY "advisorOfferings"."teamInfoId") AS "teamOfferings" 
	   ON "teamOfferings"."teamInfoId" = "teamInfos"."id" 
INNER JOIN (SELECT DISTINCT Count("id")                     AS 
						   "nservingCountries", 
						   "servingCountries"."teamInfoId" AS 
				 "servingCountries_teamCountries", 
						   "servingCountries"."teamInfoId" 
		   FROM   "servingCountries" 
		   GROUP  BY "servingCountries"."teamInfoId") AS "teamCountries" 
	   ON "teamCountries"."teamInfoId" = "teamInfos"."id" 
INNER JOIN (SELECT DISTINCT Count("id")                       AS 
						   "ninvestmentServices", 
						   "investmentServices"."teamInfoId" AS 
				 "investmentServices_teamServices", 
						   "investmentServices"."teamInfoId" 
		   FROM   "investmentServices" 
		   GROUP  BY "investmentServices"."teamInfoId") AS 
		  "teamServices" 
	   ON "teamServices"."teamInfoId" = "teamInfos"."id" 
INNER JOIN (
    SELECT 
		"addresses"."advisorId",
		MIN(POINT(37.5677679, -122.05221770000003) <@> POINT("latitude", "longitude")) AS "distance"
	FROM addresses
    INNER JOIN "geocodings" as "geo"
    ON "geo"."addressId" = "addresses"."id"
	GROUP BY "addresses"."advisorId"
) as "geoAdd"
ON "geoAdd"."advisorId" = "advisors"."id"
ORDER BY "distance"