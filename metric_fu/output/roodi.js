              var g = new Bluff.Line('graph', "1000x600");
      g.theme_37signals();
      g.tooltips = true;
      g.title_font_size = "24px"
      g.legend_font_size = "12px"
      g.marker_font_size = "10px"

        g.title = 'Roodi: design problems';
        g.data('roodi', [0,0,0]);
        g.labels = {"0":"9/3","1":"9/4","2":"9/15"};
        g.draw();
