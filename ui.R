


dashboardPage(
    
    dashboardHeader(title = 'Netflix Content Analysis', titleWidth = 250),

    
    dashboardSidebar( 
        
        width = 250,
        
    	sidebarUserPanel('Netflix', image = 'https://cdn.vox-cdn.com/thumbor/Yq1Vd39jCBGpTUKHUhEx5FfxvmM=/39x0:3111x2048/1200x800/filters:focal(39x0:3111x2048)/cdn.vox-cdn.com/uploads/chorus_image/image/49901753/netflixlogo.0.0.png'),
        
        sidebarMenu(
            menuItem('Information', tabName = 'info', icon = icon('book')),
        	  menuItem('General', tabName = 'general', icon = icon('file-video')),
            menuItem('Subscribers', tabName = 'subscribers', icon = icon('users')),
            menuItem('Map', tabName = 'map', icon = icon('globe-americas')),
            menuItem('Content Type', tabName = 'type', icon = icon('tv')),
            menuItem('Actors', tabName = 'actors', icon = icon('portrait')),
            menuItem('Content Category', tabName = 'category', icon = icon('video')),
        	  menuItem('Data', tabName = 'data', icon = icon('database'))
    	
 
                     )
    	              ),
    
    dashboardBody(
        
        
        tabItems(
            
            
            tabItem(tabName = 'info',
                    
                    fluidPage(box(h3('Subject of the Research'),
                                  h4('Netflix is an American media-services provider whose primary business is its subscription-based streaming service, 
                                     which offers online streaming of a library of films and television programs. 
                                     Service is available to users in 190 countries, with the selection of content varying depending on location due 
                                     to licensing agreements. Service is notably absent from China, Syria, and North Korea.'),
                                  br(),
                                  h3('Data'),
                                  h4('Research is based on the data obtained from the resource called Flixable, which allows users to 
                                     search through all the Movies and TV Shows available on Netflix in the United States. Dataset contains information 
                                     on every single title available for streaming in the United States as of the end  
                                     of 2019, with information on the key characteristics, among them: date of addition to Netflix, length, cast,
                                     countries of origin, etc. Dataset can be accessed through the following link.'),
                                  uiOutput("tab"),
                                  br(),
                                  h3('Key Questions'),
                                  h4('- What is the structure of the content based on various characteristics (rating, genre, etc.)?'),
                                  h4('- What, if any, seasonality is present in terms of the content addition dynamics?'),
                                  h4('- Which countries produce the most content available?'),
                                  h4('- Which actors are most frequently featured in movies or tv shows?'),
                                  h4('- What is the subscribers\' dynamics and its correlation with the number of titles available?'),
                                  br(),
                                  h3('Further Research'),
                                  h4('Due to the nature of the used data some of the additional key questions cannot be answered
                                     without extra pieces of information.'),
                                  h4('Some of the aspects of future research can include:'),
                                  h4('- "Deletion" vs "Addition" of content dynamics'),
                                  h4('- Number of titles available on Netflix at any given point of time since the beginning'),
                                  h4('- More detailed subscribers information, to look into the dynamics at the moments right after 
                                     the release of highly anticipated titles (e.g., Strangers Things, The Witcher, The Crown, etc.)'),
                                  h4('- Information on the number of free trials of the service and their dynamics analyzed for seasonality 
                                     and correlation with the release of highly anticipated titles'),
                                  h4('- Data on user retention periods'),
                                  h4('- Information on the average title availability period'),
                                  h4('- Information on the average time spent by user watching the content'),
                                  
                                  
                                  status = 'danger', width = 12))
                    
                    ),

        	tabItem(tabName = 'general',

        		fluidRow(valueBoxOutput('ntitles'),
                         valueBoxOutput('nsubscribers'),
                         valueBoxOutput('years')),

        		fluidRow(box(status = 'danger', title = 'Content Structure by Month and Year of Addition', htmlOutput('general')),
        	           	 box(status = 'danger', title = 'Title Structure by Addition Year', htmlOutput('titles'))),
        		
        		fluidRow(box(status = 'danger', title = 'Title Addition Dynamics by Each Month', htmlOutput('month'), width = 12))



        		),

        	tabItem(tabName = 'map',
        	        
                    	   fluidRow(valueBoxOutput('ncountries'),
                    	            valueBoxOutput('topcountry'),
                    	            valueBoxOutput('toppercent')),
        	        
        	                fluidRow(box(htmlOutput('map'), title = 'Content by the Country of Origin',
        	                             status = 'danger',
        	                             width = 9),
        	                         box(selectizeInput('continent', 'Pick a Continent', 
        	                                            choices = c('World','Europe', 'Asia', 'Americas', 'Africa', 'Oceania')),
        	                             title = 'Content by the Continent of Origin',
        	                             status = 'danger',
        	                             width = 3))
        	       ),
        	
        	
        	tabItem(tabName = 'subscribers',
        	        fluidRow(box(htmlOutput('subs'),status = 'danger', width = 6,
        	                     title = 'Number of Subscribers'),
        	                 box(htmlOutput('scatter'),status = 'danger', width = 6,
        	                     title = 'More titles = More subscribers?')),
        	        
        	        fluidRow(box(htmlOutput('avg.age'),title = 'Average Age of Content Added',status = 'danger', width = 12))
        	        
        	),
        	
        	
        	tabItem(tabName = 'type',
        	        fluidRow(box(status = 'danger', title = 'Content Structure by Type', htmlOutput('type1'), width = 5),
        	                 box(status = 'danger', title = 'Movies vs TV Shows Addition Dynamics', htmlOutput('type2'), width = 7)),
        	        
        	        fluidRow(box(status = 'danger', title = 'Average Movie Length Dynamics', htmlOutput('movie'), width = 12))
        	        
        	),
        	
        	
        	
        	
        	tabItem(tabName = 'category',
        	        fluidRow(box(htmlOutput('cat2'),title = 'Content Category Addition Dynamics',status = 'danger',width = 9, height = 360),
        	                 box(radioButtons("radio", label = "Choose Category",
        	                              choices = list("International" = "International", "Dramas" = 'Dramas', "Comedies" = 'Comedies', 'Action' = 'Action & Adventure',
        	                                             'Documentaries' = 'Documentaries', 'Romantic' = 'Romantic', 'Independent' = 'Independent', 'Thrillers' = 'Thrillers'), 
        	                              selected = 'International'), title = 'Select Addition Dynamics for Most Popular Categories',
        	                     width = 3,height = 360, status = 'danger')),
        	        
        	        fluidRow(box(htmlOutput('rating'),title = 'Content Structure by Age Rating',status = 'danger',width = 6),
        	                 box(htmlOutput('cat1'),title = 'Content Structure by Category',status = 'danger', width = 6)),
        	        
        	        
        	),
        	
        	tabItem(tabName = 'actors',
                	        fluidRow(box(selectizeInput('cast', 'Pick US or Global', 
                	                                    choices = c('Global','United States')),
                	                     title = 'Most Frequent Actors Internationaly vs United States',
                	                     status = 'danger', height = 150,width = 6),
                	                 
                	                 box(sliderInput('slider', label = 'Select number of top most popular actors',
                	                                 min = 1, max = 25, value = 5),
                	                     title = 'How many top actors you want to see',
                	                     status = 'danger', width = 6, height = 150),
                	                 
                	                 box(htmlOutput('actors'), title = 'Most Frequent Actors on Netflix',
                	                     status = 'danger',  width = 12))
        	       ),
        	

		    tabItem(tabName = 'data',  
			               fluidRow(box(DT::dataTableOutput("table"), 
			            	             status = 'danger',
			            		width = 12))
		           )



        	   ) 
            
        
           ),
    
    
    skin = 'red'
 
)









# tabItem(tabName = 'map',
#         fluidRow(box(htmlOutput('map'), status = 'danger', 
#                      width = 12))