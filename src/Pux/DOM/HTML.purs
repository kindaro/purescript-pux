module Pux.DOM.HTML where

import CSS.Render (render, renderedSheet)
import CSS.Stylesheet (CSS)
import Data.Function (($))
import Data.Functor (map)
import Data.Maybe (fromMaybe)
import Pux.DOM.Events (DOMEvent, mapEventHandler)
import Text.Smolder.HTML (style) as E
import Text.Smolder.Markup (MarkupM(Return, Content, Element), Markup, text)

-- | A type for HTML markup, parametized by the events it may trigger. It is a
-- | synonym for the `Markup` monad from
-- | [purescript-smolder](https://pursuit.purescript.org/packages/purescript-smolder).
type HTML ev = Markup (DOMEvent -> ev)

-- | Memoize child view and map event handlers with parent event type.
-- |
-- | It's important that `child` is only used at a top-level declaration and
-- | not inside a view. This is because PureScript is eagerly evaluated like
-- | JavaScript. If `child` is used inside a view it will recreate the memoized
-- | function every time the view is called.
child :: ∀ s a b. (a -> b) -> (s -> HTML a) -> (s -> HTML b)
child f view = memoize $ \s -> mapEvent f (view s)

-- | Map HTML with event type `a` to HTML with event type `b`.
-- |
-- | It's important that `memoize` is only used at a top-level declaration –
-- | not inside a view. This is because PureScript is eagerly evaluated like
-- | JavaScript. If `memoize` is used inside a view it will recreate the memoized
-- | function every time the view is called.
mapEvent :: ∀ a b. (a -> b) -> HTML a -> HTML b
mapEvent f (Element n c a e r) =
  Element n (map (mapEvent f) c) a (map (mapEventHandler f) e) (mapEvent f r)
mapEvent f (Content str rest) =
  Content str (mapEvent f rest)
mapEvent f (Return a) =
  Return a

-- | Memoize view. Uses JavaScript equality to match states.
-- |
-- | It's important that `memoize` is only used at a top-level declaration and
-- | not inside a view. This is because PureScript is eagerly evaluated like
-- | JavaScript. If `memoize` is used inside a view it will recreate the memoized
-- | function every time the view is called.
foreign import memoize :: ∀ st ev. (st -> HTML ev) -> (st -> HTML ev)

-- | Render CSS stylesheet and return a style element.
style :: ∀ ev. CSS -> HTML ev
style css = E.style $ text $ fromMaybe "" (renderedSheet (render css))
