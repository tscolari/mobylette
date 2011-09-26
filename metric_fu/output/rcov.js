              var g = new Bluff.Line('graph', "1000x600");
      g.theme_37signals();
      g.tooltips = true;
      g.title_font_size = "24px"
      g.legend_font_size = "12px"
      g.marker_font_size = "10px"

        g.title = 'Rcov: code coverage';
        g.data('rcov', [52.7,50.0,49.4,47.6,47.6]);
        g.labels = {"0":"9/3","1":"9/4","2":"9/15","3":"9/16","4":"9/26"};
        g.draw();
