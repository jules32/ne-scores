# Assigning Massachussetts counties to OHI regions

# Since MA splits between two biogeographical regions, and a lot of our data will be at the county level, we will have to manually assign the counties to each region.
# What makes this complicated is that a couple counties are found in both.

ma_cntys <- c('Barnstable','Barnstable','Bristol','Nantucket','Dukes','Plymouth','Plymouth','Norfolk','Essex','Suffolk')

df <- data.frame(County = ma_cntys,
                 rgn_name = c('Massachusetts-Gulf of Maine',
                              'Massachusetts-Virginian',
                              'Massachusetts-Virginian',
                              'Massachusetts-Virginian',
                              'Massachusetts-Virginian',
                              'Massachusetts-Virginian',
                              'Massachusetts-Gulf of Maine',
                              'Massachusetts-Gulf of Maine',
                              'Massachusetts-Gulf of Maine',
                              'Massachusetts-Gulf of Maine'
                              ),
                 rgn_id = c(4,5,5,5,5,5,4,4,4,4))

write.csv(df,file = '~/github/ohi-northeast/src/tables/MA_counties.csv')
