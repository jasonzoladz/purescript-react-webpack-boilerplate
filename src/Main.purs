module Main where

import Prelude
import Control.Monad.Eff
import Control.Monad.Eff.Console

import Data.Maybe.Unsafe (fromJust)
import Data.Nullable (toMaybe)

import DOM (DOM())
import DOM.HTML (window)
import DOM.HTML.Types (htmlDocumentToDocument)
import DOM.HTML.Window (document)

import DOM.Node.NonElementParentNode (getElementById)
import DOM.Node.Types (Element(), ElementId(..), documentToNonElementParentNode)

import React
import ReactDOM (render)
import React.DOM as D
import React.DOM.Props as P


hello :: forall props. ReactClass { name :: String | props }
hello = createClass $ spec unit $ \ctx -> do
  props <- getProps ctx
  return $
    D.h1 []
         [ D.text "Hello, "
         , D.text props.name
         ]

main :: forall eff.  Eff (dom :: DOM | eff ) Unit
main = void (elm' >>= render ui)
  where
    ui :: ReactElement
    ui = D.div' [ createFactory hello { name: "Jason"} ]



elm' :: forall eff. Eff (dom :: DOM | eff) Element
elm' = do
  win <- window
  doc <- document win
  elm <- getElementById (ElementId "app") (documentToNonElementParentNode (htmlDocumentToDocument doc))
  return $ fromJust (toMaybe elm)
