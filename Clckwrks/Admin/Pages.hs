{-# OPTIONS_GHC -F -pgmFtrhsx #-}
module Clckwrks.Admin.Pages where

import Clckwrks                (AdminURL(..), Clck, ClckURL(..), PageId(..), Response, query)
import Clckwrks.Admin.URL      (AdminURL(..))
import Clckwrks.Admin.Template (template)
import Clckwrks.Page.Acid      (PagesSummary(..))
import Clckwrks.Page.Types     (Slug(..))
import Data.Text               (Text)
import HSP

pages :: Clck AdminURL Response
pages =
    do pages <- query PagesSummary
       template "page list" () $ editList pages

editList ::  [(PageId, Text, Maybe Slug)] -> GenChildList (Clck AdminURL)
editList [] = <%><p>There are currently no pages.</p></%>
editList pgs =
    <%>
     <p>Edit Page</p>
     <ul class="plain-list">
      <% mapM editPageLI pgs %>
     </ul>
    </%>
    where
      editPageLI :: (PageId, Text, Maybe Slug) -> GenXML (Clck AdminURL)
      editPageLI (pid, ttl, _slug) =
          <li><a href=(EditPage pid)><% ttl %></a></li>
