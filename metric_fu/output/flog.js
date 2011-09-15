              var g = new Bluff.Line('graph', "1000x600");
      g.theme_37signals();
      g.tooltips = true;
      g.title_font_size = "24px"
      g.legend_font_size = "12px"
      g.marker_font_size = "10px"

        g.title = 'Flog: code complexity';
        g.data('average', [6.170522209788225,6.280482409477331,6.044716045990605]);
        g.data('top 5% average', [22.24909577429176,26.31890267321719,20.600711754461287])
        g.labels = {"0":"9/3","1":"9/4","2":"9/15"};
        g.draw();
