<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet 
     version="1.0" 
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:fo="http://www.w3.org/1999/XSL/Format">
<xsl:template match="/">

<fo:root>
  <fo:layout-master-set>
    <fo:simple-page-master master-name="A4" page-width="297mm"
page-height="210mm" margin-top="1cm" margin-bottom="1cm"
margin-left="1cm" margin-right="1cm">
  <fo:region-body margin="2cm"/>
  <fo:region-before extent="2cm"/>
  <fo:region-after extent="2cm"/>
  <fo:region-start extent="2cm"/>
  <fo:region-end extent="2cm"/>
</fo:simple-page-master>
  </fo:layout-master-set>
  <fo:page-sequence master-reference="A4">
     <fo:flow flow-name="xsl-region-body" font="12pt Times">     
       <fo:block-container position="fixed" top="10mm" left="250mm">
         <fo:block>
          <fo:external-graphic src="cwa_logo.png" content-width="1in"/>
          </fo:block>                   
        </fo:block-container>

    
      
       <fo:table table-layout="fixed" width="100%">
         <fo:table-column column-width="170mm"/>
         <fo:table-column column-width="100mm"/>
         <fo:table-body>
           <fo:table-row>
             <fo:table-cell>
               <fo:block text-align ="left" font="30pt Times" font-weight="bold"><xsl:value-of select="report/front_page/title_section/title" /> </fo:block>
             </fo:table-cell>
             <fo:table-cell >                
                 <fo:block>Reporting period:<xsl:value-of select="report/front_page/dates/reporting/text()" /> </fo:block>
                 <fo:block>Baseline : <xsl:value-of select="report/front_page/dates/baseline/text()" />   </fo:block>
             </fo:table-cell>
           </fo:table-row>
           <fo:table-row>
             <fo:table-cell>
               <fo:block></fo:block>
             </fo:table-cell>
             <fo:table-cell >                
                 <fo:block></fo:block>                 
             </fo:table-cell>
           </fo:table-row>
         </fo:table-body>
       </fo:table>  

  <fo:table table-layout="fixed" width="100%">
      <fo:table-column column-width="150mm"/>
         <fo:table-column column-width="100mm"/>
         <fo:table-body>
           <fo:table-row>
             <fo:table-cell>
               <fo:block text-align ="center" font="20pt Times">Visits </fo:block>
               
             </fo:table-cell>
             <fo:table-cell >                
                 <fo:block></fo:block>
             </fo:table-cell>
           </fo:table-row>
           <fo:table-row>
             <fo:table-cell>
               <fo:block><fo:external-graphic src="{report/front_page/main_graph/external_graphic}" content-width="5in"/> </fo:block>
               
             </fo:table-cell>
             <fo:table-cell >                
                 <fo:block></fo:block>
             </fo:table-cell>
           </fo:table-row>
           <fo:table-row>
             <fo:table-cell>
               <fo:block text-align ="left" font="15pt Times"> Traffic Sources </fo:block>               
             </fo:table-cell>
             <fo:table-cell >                
                 <fo:block></fo:block>
             </fo:table-cell>
           </fo:table-row>
           <fo:table-row>
            <fo:table-cell>
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="75mm"/>
                 <fo:table-column column-width="75mm"/>
                 <fo:table-body>
                  <fo:table-row>
                   <fo:table-cell>
                                      <fo:table table-layout="fixed" width="100%">
                   <fo:table-column column-width="30mm"/>
                   <fo:table-column column-width="10mm"/>
                   <fo:table-column column-width="20mm"/>
                   <fo:table-column column-width="20mm"/>
                   <fo:table-body>
                      <fo:table-row>
                        <fo:table-cell>
                           <fo:block text-align ="left" font="10pt Times">Source</fo:block>               
                        </fo:table-cell>
                        <fo:table-cell >                
                           <fo:block text-align ="left" font="10pt Times"> Visits </fo:block>   
                        </fo:table-cell>            
                        <fo:table-cell>
                          <fo:block text-align ="left" font="10pt Times"> Bounces</fo:block>               
                        </fo:table-cell>
                        <fo:table-cell >                
                           <fo:block text-align ="left" font="10pt Times"> Time </fo:block>   
                        </fo:table-cell>                       
                      </fo:table-row>
                     <xsl:for-each select="report/front_page/traffic_sources/source">

                       <fo:table-row>
                        <fo:table-cell>
                           <fo:block text-align ="left" font="8pt Times"><xsl:value-of select="source_name" /> </fo:block>               
                        </fo:table-cell>
                        <fo:table-cell >                
                           <fo:block text-align ="left" font="8pt Times"> <xsl:value-of select="visits" /> </fo:block>   
                        </fo:table-cell>            
                        <fo:table-cell>
                          <fo:block text-align ="left" font="8pt Times"> <xsl:value-of select="bouncerate" /></fo:block>               
                        </fo:table-cell>
                        <fo:table-cell >                
                           <fo:block text-align ="left" font="8pt Times"><xsl:value-of select="avg_session" /> </fo:block>   
                        </fo:table-cell>
                        </fo:table-row>
                      </xsl:for-each>

                 </fo:table-body>
              </fo:table>             
                   </fo:table-cell>
                  <fo:table-cell >                
                  <fo:table table-layout="fixed" width="100%">
                   <fo:table-column column-width="30mm"/>
                   <fo:table-column column-width="10mm"/>
                   <fo:table-column column-width="20mm"/>
                   <fo:table-column column-width="20mm"/>
                   <fo:table-body>
                      <fo:table-row>
                        <fo:table-cell>
                           <fo:block text-align ="left" font="10pt Times">By Country</fo:block>               
                        </fo:table-cell>
                        <fo:table-cell >                
                           <fo:block text-align ="left" font="10pt Times"> Visits </fo:block>   
                        </fo:table-cell>            
                        <fo:table-cell>
                          <fo:block text-align ="left" font="10pt Times"> Bounces</fo:block>               
                        </fo:table-cell>
                        <fo:table-cell >                
                           <fo:block text-align ="left" font="10pt Times"> Time </fo:block>   
                        </fo:table-cell>                       
                      </fo:table-row>
                     <xsl:for-each select="report/front_page/geographic_sources/country">

                       <fo:table-row>
                        <fo:table-cell>
                           <fo:block text-align ="left" font="8pt Times"><xsl:value-of select="country_name" /> </fo:block>               
                        </fo:table-cell>
                        <fo:table-cell >                
                           <fo:block text-align ="left" font="8pt Times"> <xsl:value-of select="visits-total" /> </fo:block>   
                        </fo:table-cell>            
                        <fo:table-cell>
                          <fo:block text-align ="left" font="8pt Times"> <xsl:value-of select="bounce_rate" /></fo:block>               
                        </fo:table-cell>
                        <fo:table-cell >                
                           <fo:block text-align ="left" font="8pt Times"><xsl:value-of select="avg_session" /> </fo:block>   
                        </fo:table-cell>
                        </fo:table-row>
                      </xsl:for-each>

                 </fo:table-body>
              </fo:table>
                </fo:table-cell>
               </fo:table-row>
             </fo:table-body>
            </fo:table>

           </fo:table-cell>
         </fo:table-row>


           
         </fo:table-body>
       </fo:table>    
         
       
      
    </fo:flow>
  
 
  </fo:page-sequence>
</fo:root>
</xsl:template>

</xsl:stylesheet>

