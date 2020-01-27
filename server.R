function (input, output) {
  
  url <- a(h4("Netflix Dataset"), href = "https://www.kaggle.com/shivamb/netflix-shows")
  output$tab <- renderUI ({
    tagList(url)
  })
  
  output$ntitles <- renderValueBox ({
    n_titles = nrow(netflix)
    valueBox(n_titles, 'Number of Titles Available',icon = icon('list'), color = 'red')
  })     
  
  output$nsubscribers <- renderValueBox({
    december2019_subscribers = Netflix_Subscribers[Netflix_Subscribers$year == 2019,][12,3][[1]]
    valueBox(paste(december2019_subscribers,sep = ' ', 'million'), 'Number of Subscribers', 
             icon = icon("money-bill"), color = 'red')
  })
  
  
  output$years <- renderValueBox(
    valueBox('2007','Active Since', 
            icon = icon("globe"), color = 'red'))
  
    
  netflix %>% 
    select(Month = month, Year = added_year) %>% 
    mutate(Year = as.character(Year)) %>% 
    group_by(Month, Year) %>% 
    summarize(Total = n()) %>% 
    arrange(desc(Total)) %>% 
    ungroup(Month, Year) -> netflix2
    
  output$general = renderGvis({
    gvisSankey(netflix2, from='Month', to = 'Year', weight = 'Total',
               options=list(
                 height= 280, width = 'auto',
                 title="Structure by Addition Date",
                 sankey="{link: {color: 'grey80' },
                            node: { color: { fill: '#a61d4c' },
                            label: { color: 'grey20' } }}"))
    
    
  })
  
  netflix %>% 
    select(year = added_year) %>% 
    group_by(year) %>% 
    summarize(total = n()) %>%
    arrange(year) %>% 
    mutate(start = total, finish = total) -> netflix.year
  
  netflix.year[1,3] = 0
  
  for (i in 2:nrow(netflix.year)) {
    netflix.year$start[i] = netflix.year$finish[i-1]
    netflix.year$finish[i] = netflix.year$start[i] + netflix.year$total[i]
  }
  
  
  netflix.year[6,1] = 'Total'
  netflix.year[6,2] = sum(netflix.year$total, na.rm = TRUE)
  netflix.year[6,3] = 0
  netflix.year[6,4] = 6234
  
  netflix.year %>% 
    transmute(year = as.character(year), start1 = start, start2 = start,
              finish1 = finish, finish2 = finish) -> netflix.year
  
  
  
  
  output$titles = renderGvis({
          gvisCandlestickChart(netflix.year,
                            options=list(
                              title="Titles Addition by Year",
                              vAxis="{title:'Number of titles', ticks: [1000,3000,5000, 7000]}",
                              colors = "['#b22222']",
                              legend =  "none",
                              fontSize =  '14',
                              height = 280,
                              width = 'auto',
                              bold = TRUE))
  
  })
  
  
  netflix %>% 
    select(month) %>%
    mutate(month = substr(month, 1,3)) %>% 
    group_by(month) %>% 
    summarize(total = n()) -> netflix.month
  
  netflix.month = netflix.month[c(5,4,8,1,9,7,6,2,12,11,10,3),]  
  
  output$month = renderGvis({
    
    gvisLineChart(netflix.month, options=list(
    lineWidth=3, pointSize=0,
    title="Average Number of Titles Added by Month",
    curveType = 'function',
    # isStacked = 'percent',
    legend = 'none',
    width='auto', height=280,
    fontSize =  '14',
    bold = TRUE,
    colors = "['#b22222']"
    # lineDashStyle = '[4, 4]'
    ))
    
  })
  
  output$ncountries <- renderValueBox ({
    n_titles = nrow(netflix)
    valueBox(nrow(unique(new.country)), 'Countries Involved',icon = icon('flag'), color = 'red')
  })     
  
  output$topcountry <- renderValueBox({
    valueBox('United States', 'Country with the most titles', 
             icon = icon("trophy"), color = 'red')
  })
  
  
  output$toppercent <- renderValueBox({
    share = round(new.country[new.country$country == 'United States', ][2]/(sum(new.country$total))*100,1)
    valueBox(paste0(share,'%'),'Share of all titles produced involving US', 
             icon = icon("cookie-bite"), color = 'red')
    })
  
  
  
  
  country = c()
  for (i in netflix$country) {
    x = strsplit(i, split = ', ')[[1]]
    x = str_remove_all(x,',')
    country = c(country, x)
  }
  
  
  data.frame(country) %>% 
    group_by(country) %>% 
    summarize(total = n()) -> new.country
  new.country[new.country$country == 'United States', ][2]/(sum(new.country$total))*100
  
  regionInput <- reactive({
    switch(input$continent,
           "World" = 'world',
           "Europe" = '150',
           "Asia" = '142',
           "Americas" = '019',
           "Africa" = '002',
           "Oceania" = '009')
  })
  
  output$map = renderGvis({
    gvisGeoChart(new.country, locationvar = "country", colorvar = "total",
                 options=list(region = regionInput(), width = 'auto', height = '550', colors = "['bisque', 'red']"))
    
    
  })
  
  
  Netflix_Subscribers %>% 
    unite(year, month,sep = ' ', col = 'date') %>% 
    mutate(date = parse_date(date, format = '%Y %B')) -> m
  
  output$subs = renderGvis({
    gvisAreaChart(m, options=list(
      lineWidth=3, pointSize=0,
      title="Total Number of Subscribers",
      curveType = 'function',
      vAxis = "{title: 'Number of suscribers,mil', ticks: [50,75,100,125,150,175]}",
      width= 'auto', height = 300,
      legend =  "none",
      fontSize =  '14',
      bold = TRUE,
      colors = "['#b22222']"))
    
  })
  
  
  
  netflix %>% 
    select(year = added_year, month, subscribers) %>% 
    group_by(year, month) %>% 
    summarize(total = n(), avg = mean(subscribers, na.rm = T)) %>% 
    unite(year,month, sep = ' ', col = 'date') %>% 
    mutate(date = parse_date(date, format = '%Y %B')) %>% 
    arrange(date) %>% 
    mutate(up_to_date = total, sub = avg - 54.4) %>% 
    select(total, sub, up_to_date) -> netflix.sub
  
  
  for (i in 2:nrow(netflix.sub)) {
    netflix.sub$up_to_date[i] = netflix.sub$total[i] + netflix.sub$up_to_date[i-1]
  }
  
  
  output$scatter = renderGvis({
    gvisScatterChart(netflix.sub[,3:2],
                     options=list(
                       title="Increase in number of titles vs Increase in subscrtiptions (since 2015)",
                       hAxis="{title:'Total Number of Titles', ticks: [1000,3000,5000,7000]}",
                       vAxis = "{title: 'Subscribers, mil',ticks: [0,25,50,75,100,125]}",
                       trendlines = "{ 0: {type: 'polynomial',color: '#3b3d41', opacity: 0.7} }", 
                       colors = "['#b22222']",
                       legend =  "none",
                       fontSize = '14',
                       bold = TRUE,
                       width='auto', height=300))
  })
  
  
  netflix %>% 
    select(type) %>% 
    group_by(type) %>% 
    summarize(total = n()) -> netflix.type
  
  output$type1 = renderGvis ({
    gvisPieChart(netflix.type,
                 option = list(
                   width = 'auto', height = 300,
                   legend = 'right',
                   fontSize =  '14',
                   bold = TRUE,
                   title= "Content Structure by Category",
                   colors = "['#8b0000','#cd0000','#EE2C2C','#ff6a6a']"
                 ))  
  })
  
  netflix %>% 
    select(added_year, type) %>% 
    group_by(type, added_year) %>% 
    summarize(Total = n()) %>% 
    spread(type, Total) %>% 
    mutate(added_year = as.character(added_year)) -> netflix.type.d
  
  
 output$type2 = renderGvis({
   gvisAreaChart(netflix.type.d, options=list(
    lineWidth=3, pointSize=0,
    title="Title Addition Structure by Year",
    curveType = 'function',
    isStacked = 'percent',
    vAxis = "{ticks: [0.5,0.6,0.7,0.8,1]}",
    width='auto', height=300,
    fontSize =  '14',
    bold = TRUE,
    colors = "['#262626', '#b22222']"
  ))
  
 })
 
 
 netflix %>% 
   select(type, duration, added_year) %>% 
   filter(type == 'Movie') %>% 
   mutate(duration =  as.numeric(duration), added_year = as.character(added_year)) %>% 
   group_by(added_year, type) %>% 
   summarize(average = mean(duration))  -> netflix.duration
 
 
output$movie = renderGvis({
  gvisLineChart(netflix.duration, options=list(
   lineWidth=3, pointSize=0,
   title="Average Movie Duration",
   curveType = 'function',
   # isStacked = 'percent',
   width='auto', height=300,
   vAxis = "{title: 'Movie Duration, minutes'}",
   fontSize =  '14',
   bold = TRUE,
   legend = 'none',
   colors = "['#b22222']",
   animation = '{"startup": true}'
 ))
  
}) 



category = c()
for (i in netflix$listed_in) {
  x = strsplit(i, split = ', ')[[1]]
  category = c(category, x)
}

category = category %>% 
  str_replace('TV', '') %>% 
  str_replace('Shows','') %>% 
  str_replace('Movies', '') %>% 
  str_trim()

data.frame(category) %>% 
  group_by(category) %>% 
  summarize(total = n()) %>% 
  arrange(desc(total)) -> netflix.category

output$cat1 = renderGvis({
gvisPieChart(netflix.category,
                  option = list(
                    width = 'auto', height = 300,
                    legend = 'right',
                    fontSize =  '14',
                    bold = TRUE,
                    title= "Content Structure by Category",
                    colors = "['#8b0000','#cd0000','#EE2C2C','#ff6a6a']"
                  ))
  
})


output$cat2 = renderGvis({
  gvisLineChart(netflix %>% 
                  filter(str_detect(listed_in, input$radio)) %>% 
                  select(year = added_year, month) %>% 
                  unite(year, month, sep = ',', col = 'date') %>% 
                  mutate(date = parse_date(date, format = '%Y,%B')) %>% 
                  group_by(date) %>% 
                  summarize(total = n()) %>% 
                  arrange(date),
                options=list(
    lineWidth=3, pointSize=0,
    title="Movie Categories Addition Dynamics",
    curveType = 'function',
    width='auto', height=300,
    vAxis = "{title: 'Number of titles'}",
    fontSize =  '14',
    bold = TRUE,
    legend = 'none',
    colors = "['#b22222']"
))
})

netflix %>% 
  select(year = added_year, release_year, month) %>% 
  mutate(time = year - release_year) %>% 
  select(year,month, time) %>% 
  unite(year, month, sep = ' ', col = 'date') %>% 
  mutate(date = parse_date(date, format = '%Y %B')) %>% 
  group_by(date) %>% 
  summarize(average = mean(time)) %>% 
  arrange(date) -> time.to.release


output$avg.age = renderGvis({
      gvisColumnChart(time.to.release,
                     options=list(
                       title="Average Age of Added Title",
                       vAxis="{title:'Average Age, years'}",
                       colors = "['#b22222']",
                       legend =  "none",
                       width='auto', height = 300,
                       trendlines = "{ 0: {color: '#3b3d41', opacity: 0.7, type: 'polynomial'} }"))

})
  


netflix %>% 
  select(rating) %>% 
  group_by(rating) %>% 
  summarize(total = n()) %>% 
  arrange(desc(total))-> netflix.rating


output$rating = renderGvis({
  gvisPieChart(netflix.rating,
               option = list(
                 width = 'auto', height = 300,
                 legend = 'right',
                 fontSize =  '14',
                 bold = TRUE,
                 title= "Content Structure by Rating",
                 colors = "['#8b0000','#cd0000','#EE2C2C','#ff6a6a']"
               ))
  
  
})




  #Global
  cast = c()
  for (i in netflix$cast) {
    x = strsplit(i, split = ', ')[[1]]
    cast = c(cast, x)
  }
  
  data.frame(cast) %>% 
    group_by(cast) %>% 
    summarize(total = n()) %>% 
    arrange(desc(total)) -> globalcast

  #United States
  
  cast = c()
  for (i in netflixUS$cast) {
    x = strsplit(i, split = ', ')[[1]]
    cast = c(cast, x)
  }
  
  data.frame(cast) %>% 
    group_by(cast) %>% 
    summarize(total = n()) %>% 
    arrange(desc(total)) -> usacast
  
  
  castInput <- reactive({
    switch(input$cast,
           "United States" = usacast,
           "Global" = globalcast)
  })
  
  
  
  output$actors = renderGvis({
    gvisBarChart(castInput()[1:input$slider,], 
                 options=list(
                   title="Most Popular Actors on Netflix",
                   hAxis="{title:'Number of titles'}",
                   colors = "['#b22222']",
                   legend =  "none",
                   font = '14',
                   width='auto', height= 500))
    
  })
 
  

  
  output$table = DT::renderDataTable({
    
    netflix.clean = netflix %>% 
      unite(duration, units, sep = ' ', col = 'duration') %>% 
      unite(month, added_year, sep = ' ', col = 'addeded')
    
    datatable(netflix.clean, rownames = FALSE, options = list(pageLength = 5))
    })
  

  
}

