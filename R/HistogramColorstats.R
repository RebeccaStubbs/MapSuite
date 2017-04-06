#' Histogram of data using color scheme
#'
#' @description This histogram function creates and returns a ggplot object with
#' a color scale dependent on the X value (default as all colors being grey)
#' as well as the possibility for vertical lines that describe different
#' properties of the distribution (mean, median, etc) added on top of the graph.
#'
#' @param datavector vector of color data
#' @param color_ramp color scheme for the histogram
#' @param minimum min value to display in histogram
#' @param maximum max value to display in histogram
#' @param color_value_breaks values to break colors at
#' @param dist_stats which distribution to use
#' @param mean_color color to use at mean
#' @param quantile_color color to use for quantiles
#'
#' @return ggplot histogram
#' @export
#'
#' @examples histogram_colorstats(rnorm(100))

HistogramColorstats<-function(datavector,
                               color_ramp="grey17",
                               minimum=NULL,
                               maximum=NULL,
                               color_value_breaks=NULL,
                               dist_stats=NULL,
                               mean_color="red",
                               quantile_color="black",
                               title=""){

    # Defining data/column based variables:
    if(is.null(minimum)){Min<-min(datavector)}else{Min<-minimum}
    if(is.null(maximum)){Max<-max(datavector)}else{Max<-maximum}

    # Creating the basic histogram; this will be returned if dist_stats==NULL
    hist<-ggplot() +
        geom_histogram(aes(x=datavector, fill = ..x..), bins=30, na.rm = TRUE)+
        xlim(Min, Max) +
        scale_fill_gradientn(colours=color_ramp, limits=c(minimum, maximum), values=color_value_breaks)+
        theme_tufte()+
        guides(fill=guide_colourbar(title=" ", barheight=0, barwidth=0, label=FALSE, ticks=FALSE))+
        labs(title=title,x= "",y="")+
        theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks=element_blank())

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Adding distribution markers, if desired

    if (!is.null(dist_stats)){
        # Looking to see what was included in the dist_stats list:
        quantile_values<-suppressWarnings(as.numeric(dist_stats)) # Getting any numeric values within the list
        other_values<-dist_stats[is.na(quantile_values)] # Getting any character strings within the list
        quantile_values<-sort(quantile_values[!is.na(quantile_values)]) # Ordering the numeric values included within the list

        # Adding Mean and SD, if Requested
        #-----------------------------------------------------------------------------------------------------
        # Checking to see if any weird/unrecognized inputs were entered wihthin the dist_stats list:
        rejected_statistics<-other_values[!(other_values %in% c("mean","sd"))]
        # Printing if unrecognized, non-numeric things were entered
        if (length(rejected_statistics)>0){
            cat("The following statistics are not supported by this function: ")
            print(rejected_statistics)
            cat(" The statistics currently supported are either values between 0 and 1 (as quantiles), \n")
            cat(" which can be entered either as numerics ex: 0.25, or charecter strings (ex:'0.9'). In addition \n")
            cat(" you may enter 'mean' and 'sd' as options. No other statistics are currently supported. \n")
            cat(" If you believe these statistics should be included in the list of commonly-used options, \n")
            cat(" please contact Rebecca Stubbs for inclusion.")
        }

        distribution_statistics<-data.table(type=character(0),vals=numeric(0),Statistic=character(0))

        # Adding valid named statistics
        #---------------------------------------------------------------------------------------------------------
        # Including a line for the mean, if it is requested:
        if("mean" %in% other_values){
            distribution_statistics<-rbind(distribution_statistics,
                                           data.table(type="Mean",
                                                      vals=mean(datavector),
                                                      Statistic=paste0( "Mean [", round(mean(datavector),2), "]") ))}

        # Including lines for +/- 1 SD, if it is requested
        if("sd" %in% other_values){
            distribution_statistics<-rbind(distribution_statistics,
                                           data.table(type="1 Std. Dev",
                                                      vals=mean(datavector)+sd(datavector),
                                                      Statistic=paste0( "1 Std. Dev. [", round(sd(datavector),2), "]") ))
            distribution_statistics<-rbind(distribution_statistics,
                                           data.table(type="1 Std. Dev",
                                                      vals=mean(datavector)-sd(datavector),
                                                      Statistic=paste0( "1 Std. Dev. [", round(sd(datavector),2), "]") ))}


        # Adding Any Quantile Values
        #-----------------------------------------------------------------------------------------------------
        if(length(quantile_values)>0){ # If there are any quantile values entered in the first place...

            if (max(quantile_values)>1 | min(quantile_values)<0){cat("You have included numeric values that are not between 0 and 1. These will not be included.")
                quantile_values<-quantile_values[quantile_values<=1&quantile_values>=0]}

            if(length(quantile_values>0)){ #If there are any quantile values left after having eliminating any values between 0 and 1..

                # Including lines for quantile values:
                for (val in quantile_values){
                    if (val==.5){distribution_statistics<-rbind(distribution_statistics,
                                                                data.table(type="Median",vals=quantile(datavector,val),Statistic="Median"))
                    }else{
                        distribution_statistics<-rbind(distribution_statistics,
                                                       data.table(type="Quantile",vals=quantile(datavector,val),
                                                                  Statistic=paste0("q ",val,": ",round( quantile(datavector,val),2 ))))
                    } # if the statistic was not median
                } # for val in quantile values
            } # If there are any valid quantile values

        } # Closing clause for if there were any numeric values entered in the first place...


        # Formatting the data.table and creating linetype and color themes for the different categories
        #-----------------------------------------------------------------------------------------------------

        distribution_statistics[,Statistic:=as.factor(type)]
        distribution_statistics[,Statistic:=as.factor(Statistic)]
        qtiles<-paste0("Qtiles: (",paste(quantile_values[quantile_values!=.5], collapse = ','),")")
        distribution_statistics[Statistic=="Quantile",Statistic:=qtiles]

        linetypes<-c("solid","solid","dashed","dashed")
        names(linetypes)<-c("Median","Mean","1 Std. Dev",qtiles)
        colors<-c(mean_color,quantile_color,mean_color,quantile_color)
        names(colors)<-c("Mean","Median","1 Std. Dev",qtiles)

        cls<-scale_color_manual(name="Statistic",values=colors)
        lines<-scale_linetype_manual(name="Statistic",values=linetypes)

        hist<-hist+geom_vline(data=distribution_statistics,
                              aes(xintercept=vals,
                                  linetype=Statistic,
                                  colour = Statistic),
                              show.legend = TRUE)+cls+lines+theme(plot.title=element_text(hjust = 0.5))
    }# if dist_stats is not null
    return(hist)
}
