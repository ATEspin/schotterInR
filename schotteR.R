library(ggplot2)
library(dplyr)

square<-function(x0=1,y0=1, size=1, angle=0){
  xor<-x0+size/2 #X origin (center of the square)
  yor<-y0+size/2 #Y origin (center of the square)
  
  tibble(
    x=c(x0,x0+size,x0+size,x0),
    y=c(y0,y0,y0+size,y0+size)
  )%>%mutate(x2=(x-xor)*cos(angle)-(y-yor)*sin(angle)+xor, #For rotation
             y2=(x-xor)*sin(angle)+(y-yor)*cos(angle)+yor) #for rotation
}

theme_background<-function(color='white'){
  theme(axis.ticks = element_blank(), axis.text = element_blank(),
        panel.background = element_blank(), panel.grid = element_blank(),
        plot.background = element_rect(fill = color),
        strip.background = element_rect(fill=color),strip.text = element_blank(),
        axis.title = element_blank(), legend.position = 'none')
}

Schotter<-function(ncol_s=12, nrow_s=24, control_dis=40, 
                   control_rot=100, fill_s=NA, color_s='black', alpha_s=0.2, 
                   back_color='white'){
  n<-ncol_s*nrow_s
  df.list<-list()
  for (j in 1:nrow_s){
    for (i in 1:ncol_s){
      displace<-runif(1,-j/control_dis,j/control_dis)
      rotate<-runif(1,-j/control_rot,j/control_rot)
      temp<-square(x=i+displace, y=j+displace, angle=rotate)
      temp$s<-rep(n)
      df.list[[n]]<-temp
      n<-n-1
    }
  }
  
  ggplot() + 
    lapply(df.list, function(square_data) {
      geom_polygon(data = square_data, aes(x = x2, y = y2),
                   alpha=alpha_s, fill=fill_s, color=color_s)}
    )+
    theme_background(color = back_color)+
    coord_fixed()+
    scale_y_reverse()
} 