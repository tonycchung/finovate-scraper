require 'nokogiri'
require 'open-uri'

url = 'http://www.finovate.com/fall11vid/demyst.html'
doc = Nokogiri::HTML(open("#{url}"))

p doc.css('#contentwrapper > table > tr > td > table:nth-child(3) > tr > td > div > table > tr > td > ul > li > table > tr > td > div > table > tr > td.cellpadding-left').inner_html

<td width="611" align="left" valign="top" class="cellpadding-left"><span class="title">Presenter Profile</span>
                    <strong>How they describe themselves: </strong>RiskKey’s enemy is the spreadsheet. Spreadsheets are not adequate for managing enterprise compliance. RiskKey solves this. It focuses on three things: Simplicity, Collaboration, and Results. Our web-based product includes pre-built templates to get you started, centralized project management for your team, risk assessment and audit project workflows, and beautiful reports.
                    <p><b>What they think makes them better:</b> Compliance, traditionally, has been conducted and “innovated” by auditors and accountants. We are neither. We tied our expertise in technology and security with our aptitude with the Web and created RiskKey. Nobody has taken a design-driven, simple-focused approach to compliance until now.<br>
                    </p>
                    <p><b>Key Executives:</b> Brad Garland (CEO), Henry Garland (Chairman &amp; Founder), Denis O’neil (VP of Sales), Heath Stanley (VP of Consulting Services)<br>
                    </p>
                    <p><b>Customers:</b> Numerous financial institutions across the USA leverage the product today.<br>
                    </p>
                    <p><b>Contacts:</b><br>
                        <em>Sales:</em> Henry Garland, Founder, 214-215-3215<br>
                        <em>Bus. Dev:</em> Denis O’neil, VP Sales, 817-800-8516<br>
                        <em>Press: </em>Natasha Gabriel, Marketing Consultant, 940-206-6429</p>
                    <p><img src="images/sh-divider.jpg" width="611" height="10"></p>
                    <span class="title">Video Download</span>
                    To View this Video in a New Window: Left-click on either link below.
                    <p>To Download: Right-click on the appropriate link below and select "Save Target   As..." or "Save Link As..."</p>
                    <p><img src="images/download-bullet.gif" width="14" height="14" hspace="10" align="absmiddle"><a href="videos/hd/RiskKey.mov" target="_blank">HD version of this video</a></p>
                    <p><img src="images/download-bullet.gif" width="14" height="14" hspace="10" align="absmiddle"><a href="videos/quicktime/RiskKey.mov">Non-HD smaller version for slower connections</a></p>
                    <p>To Embed: Copy and paste the codes below.</p>
                    <p><textarea name="code" id="code" style="width: 611px; height: 48px; margin: 0px; padding: 3px;" readonly="readonly" onfocus="document.getElementById('code').select();">&lt;script type="text/javascript" src="http://finovate.com/player/?width=930&amp;height=569&amp;video=%2Fspring10vid%2Fvideos%2Fhd%2FRiskKey.mov"&gt;&lt;/script&gt;&lt;noscript&gt;The video cannot be loaded as your browser does not support JavaScript.&lt;/noscript&gt; </textarea></p>
                    </td>
