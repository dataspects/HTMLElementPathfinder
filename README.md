# HTMLElementPathfinder
HTMLElementPathfinder can reveal the hierarchical tag path to an element starting from body.

## How to use

    you@yourcomputer:~/HTMLElementPathfinder$ URL='' TEXT='' ruby run.rb

## What you get

    Find '' in '':
    body class="page page--search "
      div class="l--main"
        div class="l--holder"
          div class="l--wrapper"
            section class="container"
              div class="container__body"
                div class="l--row"
                  div class="l--col l--col--2of3"
                    div class="card card--search"
                      article class="teaser"
                        a class="teaser__link"
                          div class="teaser__text"
                            h2 class="title "
                              div class="title__name"
