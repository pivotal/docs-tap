# Tanzu Application Platform release notes

This topic describes the changes in Tanzu Application Platform (commonly known as TAP)
v{{ vars.url_version }}.

## <a id='1-5-12'></a> v1.5.12

**Release Date**: 09 April 2024

### <a id='1-5-12-security-fixes'></a> v1.5.12 Security fixes

This release has the following security fixes, listed by component and area.

<table>
<thead>
<tr>
<th>Package Name</th>
<th>Vulnerabilities Resolved</th>
</tr>
</thead>
<tbody>
<tr>
<td>metadata-store.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-rcjv-mgp8-qvmr">GHSA-rcjv-mgp8-qvmr</a></li>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-m425-mq94-257g">GHSA-m425-mq94-257g</a></li>
<li><a href="https://github.com/advisories/GHSA-4374-p667-p6c8">GHSA-4374-p667-p6c8</a></li>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-45285">CVE-2023-45285</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-44487">CVE-2023-44487</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39325">CVE-2023-39325</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39323">CVE-2023-39323</a></li>
</ul></details></td>
</tr>
<tr>
<td>sso.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-26462">CVE-2024-26462</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-26461">CVE-2024-26461</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-26458">CVE-2024-26458</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0553">CVE-2024-0553</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-7008">CVE-2023-7008</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5981">CVE-2023-5981</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48303">CVE-2022-48303</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-36087">CVE-2021-36087</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-36086">CVE-2021-36086</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-36085">CVE-2021-36085</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-36084">CVE-2021-36084</a></li>
</ul></details></td>
</tr>
<tr>
<td>tap-gui.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-30589">CVE-2023-30589</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-30588">CVE-2023-30588</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0842">CVE-2023-0842</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0466">CVE-2023-0466</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4415">CVE-2022-4415</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3821">CVE-2022-3821</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-36634">CVE-2020-36634</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-17753">CVE-2020-17753</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2019-9705">CVE-2019-9705</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2019-9704">CVE-2019-9704</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2017-9525">CVE-2017-9525</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2013-1779">CVE-2013-1779</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2006-1611">CVE-2006-1611</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2002-1647">CVE-2002-1647</a></li>
</ul></details></td>
</tr>
</tbody>
</table>

---

### <a id='1-5-12-known-issues'></a> v1.5.12 Known issues

This release introduces no new known issues.

---

## <a id='1-5-11'></a> v1.5.11

**Release Date**: 12 March 2024

### <a id='1-5-11-security-fixes'></a> v1.5.11 Security fixes

This release has the following security fixes, listed by component and area.

<table>
<thead>
<tr>
<th>Package Name</th>
<th>Vulnerabilities Resolved</th>
</tr>
</thead>
<tbody>
<tr>
<td>spring-cloud-gateway.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-hr8g-6v94-x4m9">GHSA-hr8g-6v94-x4m9</a></li>
<li><a href="https://github.com/advisories/GHSA-ccgv-vj62-xf9h">GHSA-ccgv-vj62-xf9h</a></li>
<li><a href="https://github.com/advisories/GHSA-4g9r-vxhx-9pgx">GHSA-4g9r-vxhx-9pgx</a></li>
<li><a href="https://github.com/advisories/GHSA-45x7-px36-x8w8">GHSA-45x7-px36-x8w8</a></li>
<li><a href="https://github.com/advisories/GHSA-4265-ccf5-phj5">GHSA-4265-ccf5-phj5</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-26308">CVE-2024-26308</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-25710">CVE-2024-25710</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-22365">CVE-2024-22365</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-20952">CVE-2024-20952</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-20932">CVE-2024-20932</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-20926">CVE-2024-20926</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-20918">CVE-2024-20918</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0727">CVE-2024-0727</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0567">CVE-2024-0567</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0553">CVE-2024-0553</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6237">CVE-2023-6237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6129">CVE-2023-6129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5678">CVE-2023-5678</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4641">CVE-2023-4641</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39326">CVE-2023-39326</a></li>
</ul></details></td>
</tr>
<tr>
<td>tekton.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-hp87-p4gw-j4gq">GHSA-hp87-p4gw-j4gq</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-22365">CVE-2024-22365</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0567">CVE-2024-0567</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0553">CVE-2024-0553</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-7192">CVE-2023-7192</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6918">CVE-2023-6918</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6546">CVE-2023-6546</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6004">CVE-2023-6004</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5981">CVE-2023-5981</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5717">CVE-2023-5717</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5363">CVE-2023-5363</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5197">CVE-2023-5197</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5178">CVE-2023-5178</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5158">CVE-2023-5158</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4921">CVE-2023-4921</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4881">CVE-2023-4881</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-48795">CVE-2023-48795</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-47038">CVE-2023-47038</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4623">CVE-2023-4623</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4622">CVE-2023-4622</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46218">CVE-2023-46218</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-45871">CVE-2023-45871</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-45863">CVE-2023-45863</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-45862">CVE-2023-45862</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4569">CVE-2023-4569</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-44487">CVE-2023-44487</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-44466">CVE-2023-44466</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42756">CVE-2023-42756</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42755">CVE-2023-42755</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42754">CVE-2023-42754</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42753">CVE-2023-42753</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42752">CVE-2023-42752</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4273">CVE-2023-4273</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4244">CVE-2023-4244</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4208">CVE-2023-4208</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4207">CVE-2023-4207</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4206">CVE-2023-4206</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4194">CVE-2023-4194</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4155">CVE-2023-4155</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4147">CVE-2023-4147</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4132">CVE-2023-4132</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4128">CVE-2023-4128</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-40283">CVE-2023-40283</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4016">CVE-2023-4016</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4015">CVE-2023-4015</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4004">CVE-2023-4004</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3995">CVE-2023-3995</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39804">CVE-2023-39804</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39198">CVE-2023-39198</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39197">CVE-2023-39197</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39194">CVE-2023-39194</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39193">CVE-2023-39193</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39192">CVE-2023-39192</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39189">CVE-2023-39189</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3866">CVE-2023-3866</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3865">CVE-2023-3865</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3863">CVE-2023-3863</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38546">CVE-2023-38546</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38432">CVE-2023-38432</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38429">CVE-2023-38429</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38428">CVE-2023-38428</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38426">CVE-2023-38426</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3817">CVE-2023-3817</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3777">CVE-2023-3777</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3776">CVE-2023-3776</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3773">CVE-2023-3773</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3772">CVE-2023-3772</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-37453">CVE-2023-37453</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3611">CVE-2023-3611</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3610">CVE-2023-3610</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3609">CVE-2023-3609</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-36054">CVE-2023-36054</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35829">CVE-2023-35829</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35828">CVE-2023-35828</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35824">CVE-2023-35824</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35823">CVE-2023-35823</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35788">CVE-2023-35788</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3567">CVE-2023-3567</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35001">CVE-2023-35001</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3446">CVE-2023-3446</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3439">CVE-2023-3439</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34319">CVE-2023-34319</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34256">CVE-2023-34256</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3390">CVE-2023-3390</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3389">CVE-2023-3389</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3358">CVE-2023-3358</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3357">CVE-2023-3357</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3355">CVE-2023-3355</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3338">CVE-2023-3338</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-33288">CVE-2023-33288</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-33203">CVE-2023-33203</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3268">CVE-2023-3268</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32269">CVE-2023-32269</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32248">CVE-2023-32248</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32233">CVE-2023-32233</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3220">CVE-2023-3220</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3212">CVE-2023-3212</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3161">CVE-2023-3161</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31484">CVE-2023-31484</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31436">CVE-2023-31436</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3141">CVE-2023-3141</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31248">CVE-2023-31248</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3117">CVE-2023-3117</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31085">CVE-2023-31085</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31084">CVE-2023-31084</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31083">CVE-2023-31083</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3090">CVE-2023-3090</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-30772">CVE-2023-30772</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-30456">CVE-2023-30456</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2985">CVE-2023-2985</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2975">CVE-2023-2975</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29491">CVE-2023-29491</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29007">CVE-2023-29007</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2898">CVE-2023-2898</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28466">CVE-2023-28466</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28328">CVE-2023-28328</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28322">CVE-2023-28322</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28321">CVE-2023-28321</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27538">CVE-2023-27538</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27536">CVE-2023-27536</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27535">CVE-2023-27535</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27534">CVE-2023-27534</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27533">CVE-2023-27533</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26607">CVE-2023-26607</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26606">CVE-2023-26606</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26605">CVE-2023-26605</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26545">CVE-2023-26545</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26544">CVE-2023-26544</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2612">CVE-2023-2612</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2603">CVE-2023-2603</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2602">CVE-2023-2602</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25815">CVE-2023-25815</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25775">CVE-2023-25775</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25652">CVE-2023-25652</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25588">CVE-2023-25588</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25585">CVE-2023-25585</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25584">CVE-2023-25584</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25012">CVE-2023-25012</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24329">CVE-2023-24329</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23946">CVE-2023-23946</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23916">CVE-2023-23916</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23915">CVE-2023-23915</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23914">CVE-2023-23914</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23559">CVE-2023-23559</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23455">CVE-2023-23455</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23454">CVE-2023-23454</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23004">CVE-2023-23004</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2283">CVE-2023-2283</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2269">CVE-2023-2269</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22490">CVE-2023-22490</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2235">CVE-2023-2235</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2194">CVE-2023-2194</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2166">CVE-2023-2166</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2163">CVE-2023-2163</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2162">CVE-2023-2162</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2156">CVE-2023-2156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21400">CVE-2023-21400</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21255">CVE-2023-21255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2124">CVE-2023-2124</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21102">CVE-2023-21102</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20938">CVE-2023-20938</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20593">CVE-2023-20593</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20588">CVE-2023-20588</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20569">CVE-2023-20569</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2006">CVE-2023-2006</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2002">CVE-2023-2002</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1998">CVE-2023-1998</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1990">CVE-2023-1990</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1972">CVE-2023-1972</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1872">CVE-2023-1872</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1859">CVE-2023-1859</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1855">CVE-2023-1855</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1829">CVE-2023-1829</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1670">CVE-2023-1670</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1667">CVE-2023-1667</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1652">CVE-2023-1652</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1611">CVE-2023-1611</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1513">CVE-2023-1513</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1382">CVE-2023-1382</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1380">CVE-2023-1380</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1281">CVE-2023-1281</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1206">CVE-2023-1206</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1195">CVE-2023-1195</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1192">CVE-2023-1192</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1079">CVE-2023-1079</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1078">CVE-2023-1078</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1077">CVE-2023-1077</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1076">CVE-2023-1076</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1075">CVE-2023-1075</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1074">CVE-2023-1074</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1073">CVE-2023-1073</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0597">CVE-2023-0597</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0468">CVE-2023-0468</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0461">CVE-2023-0461</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0459">CVE-2023-0459</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0458">CVE-2023-0458</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0394">CVE-2023-0394</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0386">CVE-2023-0386</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0361">CVE-2023-0361</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0266">CVE-2023-0266</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0210">CVE-2023-0210</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0179">CVE-2023-0179</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0045">CVE-2023-0045</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48522">CVE-2022-48522</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48502">CVE-2022-48502</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4842">CVE-2022-4842</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48425">CVE-2022-48425</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48424">CVE-2022-48424</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48423">CVE-2022-48423</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48303">CVE-2022-48303</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47929">CVE-2022-47929</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47696">CVE-2022-47696</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47673">CVE-2022-47673</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47521">CVE-2022-47521</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47520">CVE-2022-47520</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47519">CVE-2022-47519</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47518">CVE-2022-47518</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47011">CVE-2022-47011</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47010">CVE-2022-47010</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47008">CVE-2022-47008</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47007">CVE-2022-47007</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45919">CVE-2022-45919</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45886">CVE-2022-45886</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45869">CVE-2022-45869</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45703">CVE-2022-45703</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-44840">CVE-2022-44840</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4415">CVE-2022-4415</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4382">CVE-2022-4382</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4379">CVE-2022-4379</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4285">CVE-2022-4285</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4269">CVE-2022-4269</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-42329">CVE-2022-42329</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-42328">CVE-2022-42328</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4139">CVE-2022-4139</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4129">CVE-2022-4129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-41218">CVE-2022-41218</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-40982">CVE-2022-40982</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3821">CVE-2022-3821</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3707">CVE-2022-3707</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-36280">CVE-2022-36280</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3545">CVE-2022-3545</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3521">CVE-2022-3521</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-35205">CVE-2022-35205</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3435">CVE-2022-3435</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3424">CVE-2022-3424</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3344">CVE-2022-3344</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3169">CVE-2022-3169</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-27672">CVE-2022-27672</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2196">CVE-2022-2196</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2007-4559">CVE-2007-4559</a></li>
</ul></details></td>
</tr>
</tbody>
</table>

---

### <a id='1-5-11-known-issues'></a> v1.5.11 Known issues

This release introduces no new known issues.

---

## <a id='1-5-10'></a> v1.5.10

**Release Date**: 13 February 2024

### <a id='1-5-10-security-fixes'></a> v1.5.10 Security fixes

This release has the following security fixes, listed by component and area.

<table>
<thead>
<tr>
<th>Package Name</th>
<th>Vulnerabilities Resolved</th>
</tr>
</thead>
<tbody>
<tr>
<td>application-configuration-service.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-wjxj-5m7g-mg7q">GHSA-wjxj-5m7g-mg7q</a></li>
<li><a href="https://github.com/advisories/GHSA-cgwf-w82q-5jrr">GHSA-cgwf-w82q-5jrr</a></li>
<li><a href="https://github.com/advisories/GHSA-45x7-px36-x8w8">GHSA-45x7-px36-x8w8</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42503">CVE-2023-42503</a></li>
</ul></details></td>
</tr>
<tr>
<td>carbonblack.scanning.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-6xv5-86q9-7xr8">GHSA-6xv5-86q9-7xr8</a></li>
<li><a href="https://github.com/advisories/GHSA-6wrf-mxfj-pf5p">GHSA-6wrf-mxfj-pf5p</a></li>
<li><a href="https://github.com/advisories/GHSA-33pg-m6jh-5237">GHSA-33pg-m6jh-5237</a></li>
</ul></details></td>
</tr>
<tr>
<td>ootb-templates.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-p782-xgp4-8hr8">GHSA-p782-xgp4-8hr8</a></li>
<li><a href="https://github.com/advisories/GHSA-mw99-9chc-xw7r">GHSA-mw99-9chc-xw7r</a></li>
<li><a href="https://github.com/advisories/GHSA-9763-4f94-gfch">GHSA-9763-4f94-gfch</a></li>
<li><a href="https://github.com/advisories/GHSA-7ww5-4wqc-m92c">GHSA-7ww5-4wqc-m92c</a></li>
<li><a href="https://github.com/advisories/GHSA-449p-3h89-pw88">GHSA-449p-3h89-pw88</a></li>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-22365">CVE-2024-22365</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0567">CVE-2024-0567</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0553">CVE-2024-0553</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0193">CVE-2024-0193</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-7192">CVE-2023-7192</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6932">CVE-2023-6932</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6931">CVE-2023-6931</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6918">CVE-2023-6918</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6817">CVE-2023-6817</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6606">CVE-2023-6606</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6546">CVE-2023-6546</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6040">CVE-2023-6040</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6004">CVE-2023-6004</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5981">CVE-2023-5981</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5717">CVE-2023-5717</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5363">CVE-2023-5363</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5197">CVE-2023-5197</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5178">CVE-2023-5178</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5158">CVE-2023-5158</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4921">CVE-2023-4921</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4911">CVE-2023-4911</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4881">CVE-2023-4881</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-48795">CVE-2023-48795</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-47038">CVE-2023-47038</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4623">CVE-2023-4623</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4622">CVE-2023-4622</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46218">CVE-2023-46218</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-45871">CVE-2023-45871</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-45862">CVE-2023-45862</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4569">CVE-2023-4569</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-44466">CVE-2023-44466</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42756">CVE-2023-42756</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42755">CVE-2023-42755</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42754">CVE-2023-42754</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42753">CVE-2023-42753</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42752">CVE-2023-42752</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4273">CVE-2023-4273</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4244">CVE-2023-4244</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4208">CVE-2023-4208</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4207">CVE-2023-4207</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4206">CVE-2023-4206</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4194">CVE-2023-4194</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4155">CVE-2023-4155</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4147">CVE-2023-4147</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4132">CVE-2023-4132</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4128">CVE-2023-4128</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-40283">CVE-2023-40283</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4016">CVE-2023-4016</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4015">CVE-2023-4015</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4004">CVE-2023-4004</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3995">CVE-2023-3995</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39804">CVE-2023-39804</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39198">CVE-2023-39198</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39197">CVE-2023-39197</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39194">CVE-2023-39194</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39193">CVE-2023-39193</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39192">CVE-2023-39192</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39189">CVE-2023-39189</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3866">CVE-2023-3866</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3865">CVE-2023-3865</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3863">CVE-2023-3863</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38546">CVE-2023-38546</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38545">CVE-2023-38545</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38432">CVE-2023-38432</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38429">CVE-2023-38429</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38428">CVE-2023-38428</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38426">CVE-2023-38426</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3817">CVE-2023-3817</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3777">CVE-2023-3777</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3776">CVE-2023-3776</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3773">CVE-2023-3773</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3772">CVE-2023-3772</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-37453">CVE-2023-37453</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3611">CVE-2023-3611</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3610">CVE-2023-3610</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3609">CVE-2023-3609</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-36054">CVE-2023-36054</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35829">CVE-2023-35829</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35828">CVE-2023-35828</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35824">CVE-2023-35824</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35823">CVE-2023-35823</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35788">CVE-2023-35788</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35001">CVE-2023-35001</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3446">CVE-2023-3446</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3439">CVE-2023-3439</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34319">CVE-2023-34319</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34256">CVE-2023-34256</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3390">CVE-2023-3390</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3389">CVE-2023-3389</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3338">CVE-2023-3338</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-33288">CVE-2023-33288</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-33203">CVE-2023-33203</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3268">CVE-2023-3268</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32248">CVE-2023-32248</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3212">CVE-2023-3212</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3141">CVE-2023-3141</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31248">CVE-2023-31248</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3117">CVE-2023-3117</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31085">CVE-2023-31085</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31084">CVE-2023-31084</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31083">CVE-2023-31083</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3090">CVE-2023-3090</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-30772">CVE-2023-30772</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2975">CVE-2023-2975</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2898">CVE-2023-2898</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28466">CVE-2023-28466</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28322">CVE-2023-28322</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28321">CVE-2023-28321</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25775">CVE-2023-25775</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23004">CVE-2023-23004</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2269">CVE-2023-2269</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2235">CVE-2023-2235</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2194">CVE-2023-2194</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2163">CVE-2023-2163</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2156">CVE-2023-2156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21400">CVE-2023-21400</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21255">CVE-2023-21255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2124">CVE-2023-2124</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20593">CVE-2023-20593</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20588">CVE-2023-20588</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20569">CVE-2023-20569</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2002">CVE-2023-2002</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1990">CVE-2023-1990</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1855">CVE-2023-1855</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1611">CVE-2023-1611</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1206">CVE-2023-1206</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1192">CVE-2023-1192</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0597">CVE-2023-0597</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48522">CVE-2022-48522</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48502">CVE-2022-48502</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48425">CVE-2022-48425</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47011">CVE-2022-47011</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47010">CVE-2022-47010</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47008">CVE-2022-47008</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47007">CVE-2022-47007</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45919">CVE-2022-45919</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45886">CVE-2022-45886</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45703">CVE-2022-45703</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-44840">CVE-2022-44840</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4285">CVE-2022-4285</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4269">CVE-2022-4269</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-40982">CVE-2022-40982</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-35205">CVE-2022-35205</a></li>
</ul></details></td>
</tr>
<tr>
<td>sso.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-45145">CVE-2023-45145</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-41056">CVE-2023-41056</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-41053">CVE-2023-41053</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39319">CVE-2023-39319</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39318">CVE-2023-39318</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3817">CVE-2023-3817</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-36054">CVE-2023-36054</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3446">CVE-2023-3446</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29409">CVE-2023-29409</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29406">CVE-2023-29406</a></li>
</ul></details></td>
</tr>
</tbody>
</table>

---

### <a id='1-5-10-resolved-issues'></a> v1.5.10 Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id='1-5-10-app-sso-ri'></a> v1.5.10 Resolved issues: Application Single Sign-On

- When requesting an `access_token` by using the the Authorization Code flow, scopes in the token are
  filtered based on user roles. In this version, the `scope` parameter of the
  access token response is also filtered, with the same rules.
  For more information, see the [OAuth documentation](https://www.ietf.org/archive/id/draft-ietf-oauth-v2-1-10.html#name-token-response).

#### <a id='1-5-10-contour-ri'></a> v1.5.10 Resolved issues: Contour

- Ships with Contour v1.24.6.
- Supports upgrades to Tanzu Application Platform v1.5.10 without downtime when transitioning from `DaemonSet` to `Deployments`.

    >**Note** Downtime-free upgrades require more than one nodes in the cluster.

---

### <a id='1-5-10-known-issues'></a> v1.5.10 Known issues

This release introduces no new known issues.

---

## <a id='1-5-9'></a> v1.5.9

**Release Date**: 09 January 2024

### <a id='1-5-9-security-fixes'></a> v1.5.9 Security fixes

This release has the following security fixes, listed by component and area.

<table>
<thead>
<tr>
<th>Package Name</th>
<th>Vulnerabilities Resolved</th>
</tr>
</thead>
<tbody>
<tr>
<td>api-portal.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-vmq6-5m68-f53m">GHSA-vmq6-5m68-f53m</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5981">CVE-2023-5981</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-47038">CVE-2023-47038</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4016">CVE-2023-4016</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-36054">CVE-2023-36054</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48522">CVE-2022-48522</a></li>
</ul></details></td>
</tr>
<tr>
<td>application-configuration-service.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6378">CVE-2023-6378</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-44487">CVE-2023-44487</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39325">CVE-2023-39325</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3635">CVE-2023-3635</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34053">CVE-2023-34053</a></li>
</ul></details></td>
</tr>
<tr>
<td>cnrs.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5363">CVE-2023-5363</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-45285">CVE-2023-45285</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39326">CVE-2023-39326</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3817">CVE-2023-3817</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3446">CVE-2023-3446</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2975">CVE-2023-2975</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li>
</ul></details></td>
</tr>
<tr>
<td>metadata-store.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-41717">CVE-2022-41717</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-41715">CVE-2022-41715</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2880">CVE-2022-2880</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2879">CVE-2022-2879</a></li>
</ul></details></td>
</tr>
<tr>
<td>spring-cloud-gateway.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-jjfh-589g-3hjx">GHSA-jjfh-589g-3hjx</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5981">CVE-2023-5981</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-47038">CVE-2023-47038</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4016">CVE-2023-4016</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39804">CVE-2023-39804</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34053">CVE-2023-34053</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48522">CVE-2022-48522</a></li>
</ul></details></td>
</tr>
<tr>
<td>sso.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-vmq6-5m68-f53m">GHSA-vmq6-5m68-f53m</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5363">CVE-2023-5363</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34053">CVE-2023-34053</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34035">CVE-2023-34035</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2975">CVE-2023-2975</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22049">CVE-2023-22049</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22045">CVE-2023-22045</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22044">CVE-2023-22044</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22041">CVE-2023-22041</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22036">CVE-2023-22036</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22006">CVE-2023-22006</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20863">CVE-2023-20863</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20861">CVE-2023-20861</a></li>
</ul></details></td>
</tr>
</tbody>
</table>

---

### <a id='1-5-9-known-issues'></a> v1.5.9 Known issues

This release has the following known issues, listed by component and area.

#### <a id='1-5-9-scst-scan-ki'></a> v1.5.9 Known issues: Supply Chain Security Tools - Scan

- The Snyk scanner outputs an incorrectly created date, resulting in an invalid date. If the workload
is in a failed state due to an invalid date, wait approximately 10 hours and the workload
automatically goes into the ready state. For more information, see this [issue](https://github.com/snyk-tech-services/snyk2spdx/issues/54) in the Snyk Github repository.

---

## <a id='1-5-8'></a> v1.5.8

**Release Date**: 12 December 2023

### <a id='1-5-8-security-fixes'></a> v1.5.8 Security fixes

This release has the following security fixes, listed by component and area.

<table>
<thead>
<tr>
<th>Package Name</th>
<th>Vulnerabilities Resolved</th>
</tr>
</thead>
<tbody>
<tr>
<td>api-portal.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5363">CVE-2023-5363</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3817">CVE-2023-3817</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3446">CVE-2023-3446</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2975">CVE-2023-2975</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22081">CVE-2023-22081</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22025">CVE-2023-22025</a></li>
</ul></details></td>
</tr>
<tr>
<td>apis.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5363">CVE-2023-5363</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3817">CVE-2023-3817</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3446">CVE-2023-3446</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2975">CVE-2023-2975</a></li>
</ul></details></td>
</tr>
<tr>
<td>buildservice.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-hp87-p4gw-j4gq">GHSA-hp87-p4gw-j4gq</a></li>
<li><a href="https://github.com/advisories/GHSA-4374-p667-p6c8">GHSA-4374-p667-p6c8</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5981">CVE-2023-5981</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5363">CVE-2023-5363</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5197">CVE-2023-5197</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4921">CVE-2023-4921</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4911">CVE-2023-4911</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4881">CVE-2023-4881</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4623">CVE-2023-4623</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4622">CVE-2023-4622</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-45871">CVE-2023-45871</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-44487">CVE-2023-44487</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-44466">CVE-2023-44466</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42756">CVE-2023-42756</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42755">CVE-2023-42755</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42753">CVE-2023-42753</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42752">CVE-2023-42752</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4273">CVE-2023-4273</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4244">CVE-2023-4244</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4208">CVE-2023-4208</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4207">CVE-2023-4207</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4206">CVE-2023-4206</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4194">CVE-2023-4194</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4155">CVE-2023-4155</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4132">CVE-2023-4132</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4016">CVE-2023-4016</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3866">CVE-2023-3866</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3865">CVE-2023-3865</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3863">CVE-2023-3863</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38546">CVE-2023-38546</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38545">CVE-2023-38545</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38432">CVE-2023-38432</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38429">CVE-2023-38429</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38428">CVE-2023-38428</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38426">CVE-2023-38426</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3817">CVE-2023-3817</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3772">CVE-2023-3772</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-36054">CVE-2023-36054</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35829">CVE-2023-35829</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35828">CVE-2023-35828</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35824">CVE-2023-35824</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35823">CVE-2023-35823</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3446">CVE-2023-3446</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34319">CVE-2023-34319</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34256">CVE-2023-34256</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3338">CVE-2023-3338</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3268">CVE-2023-3268</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32248">CVE-2023-32248</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3212">CVE-2023-3212</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31484">CVE-2023-31484</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3141">CVE-2023-3141</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31085">CVE-2023-31085</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31084">CVE-2023-31084</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31083">CVE-2023-31083</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2975">CVE-2023-2975</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29491">CVE-2023-29491</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2898">CVE-2023-2898</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2603">CVE-2023-2603</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2602">CVE-2023-2602</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25775">CVE-2023-25775</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23004">CVE-2023-23004</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2269">CVE-2023-2269</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2235">CVE-2023-2235</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2163">CVE-2023-2163</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2156">CVE-2023-2156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21255">CVE-2023-21255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2124">CVE-2023-2124</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1206">CVE-2023-1206</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1192">CVE-2023-1192</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48502">CVE-2022-48502</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48425">CVE-2022-48425</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-40982">CVE-2022-40982</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li>
</ul></details></td>
</tr>
<tr>
<td>cnrs.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39319">CVE-2023-39319</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39318">CVE-2023-39318</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29409">CVE-2023-29409</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29406">CVE-2023-29406</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29403">CVE-2023-29403</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24536">CVE-2023-24536</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24534">CVE-2023-24534</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24532">CVE-2023-24532</a></li>
</ul></details></td>
</tr>
<tr>
<td>developer-conventions.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-4374-p667-p6c8">GHSA-4374-p667-p6c8</a></li>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5363">CVE-2023-5363</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3817">CVE-2023-3817</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3446">CVE-2023-3446</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2975">CVE-2023-2975</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li>
</ul></details></td>
</tr>
<tr>
<td>eventing.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-m425-mq94-257g">GHSA-m425-mq94-257g</a></li>
<li><a href="https://github.com/advisories/GHSA-4374-p667-p6c8">GHSA-4374-p667-p6c8</a></li>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-44487">CVE-2023-44487</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39323">CVE-2023-39323</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39319">CVE-2023-39319</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39318">CVE-2023-39318</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29409">CVE-2023-29409</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29406">CVE-2023-29406</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29405">CVE-2023-29405</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29404">CVE-2023-29404</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29403">CVE-2023-29403</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29402">CVE-2023-29402</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29400">CVE-2023-29400</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24540">CVE-2023-24540</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24539">CVE-2023-24539</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24538">CVE-2023-24538</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24537">CVE-2023-24537</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24536">CVE-2023-24536</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24534">CVE-2023-24534</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24532">CVE-2023-24532</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-41725">CVE-2022-41725</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-41724">CVE-2022-41724</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-41723">CVE-2022-41723</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-41722">CVE-2022-41722</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-41717">CVE-2022-41717</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-41715">CVE-2022-41715</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-32189">CVE-2022-32189</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-32148">CVE-2022-32148</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-30635">CVE-2022-30635</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-30633">CVE-2022-30633</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-30632">CVE-2022-30632</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-30631">CVE-2022-30631</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-30630">CVE-2022-30630</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2880">CVE-2022-2880</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2879">CVE-2022-2879</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-28131">CVE-2022-28131</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-27664">CVE-2022-27664</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1962">CVE-2022-1962</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1705">CVE-2022-1705</a></li>
</ul></details></td>
</tr>
<tr>
<td>spring-cloud-gateway.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-xpw8-rcwv-8f8p">GHSA-xpw8-rcwv-8f8p</a></li>
<li><a href="https://github.com/advisories/GHSA-vmq6-5m68-f53m">GHSA-vmq6-5m68-f53m</a></li>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-jgvc-jfgh-rjvv">GHSA-jgvc-jfgh-rjvv</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5363">CVE-2023-5363</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4911">CVE-2023-4911</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-44487">CVE-2023-44487</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3817">CVE-2023-3817</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-36054">CVE-2023-36054</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3446">CVE-2023-3446</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2975">CVE-2023-2975</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22081">CVE-2023-22081</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22025">CVE-2023-22025</a></li>
</ul></details></td>
</tr>
</tbody>
</table>

---

### <a id='1-5-8-known-issues'></a> v1.5.8 Known issues

This release introduces no new known issues.

---

## <a id='1-5-7'></a> v1.5.7

**Release Date**: 14 November 2023

### <a id='1-5-7-security-fixes'></a> v1.5.7 Security fixes

This release has the following security fixes, listed by component and area.

<table>
<thead>
<tr>
<th>Package Name</th>
<th>Vulnerabilities Resolved</th>
</tr>
</thead>
<tbody>
<tr>
<td>api-portal.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2603">CVE-2023-2603</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2602">CVE-2023-2602</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22049">CVE-2023-22049</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22045">CVE-2023-22045</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22044">CVE-2023-22044</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22041">CVE-2023-22041</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22036">CVE-2023-22036</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22006">CVE-2023-22006</a></li>
</ul></details></td>
</tr>
<tr>
<td>contour.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-m425-mq94-257g">GHSA-m425-mq94-257g</a></li>
<li><a href="https://github.com/advisories/GHSA-4374-p667-p6c8">GHSA-4374-p667-p6c8</a></li>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-44487">CVE-2023-44487</a></li>
</ul></details></td>
</tr>
</tbody>
</table>

---

### <a id='1-5-7-known-issues'></a> v1.5.7 Known issues

This release has the following known issues, listed by component and area.

#### <a id='1-5-7-tap-ki'></a> v1.5.7 Known issues: Tanzu Application Platform

- Tanzu Application Platform v1.5.7 is not supported with Tanzu Kubernetes releases (TKR) v1.26
  on vSphere with Tanzu v8.

---

## <a id='1-5-6'></a> v1.5.6

**Release Date**: 10 October 2023

### <a id='1-5-6-breaking-changes'></a> v1.5.6 Breaking changes

This release has the following breaking changes, listed by component and area.

#### <a id='1-5-6-services-toolkit-br'></a> v1.5.6 Breaking changes: Services Toolkit

- Services Toolkit forces explicit cluster-wide permissions to `claim` from a `ClusterInstanceClass`.
  You must now grant the permission to `claim` from a `ClusterInstanceClass` by using a `ClusterRole`
  and `ClusterRoleBinding`.
  For more information, see [The claim verb for ClusterInstanceClass](./services-toolkit/reference/api/rbac.hbs.md#claim-verb).

---

### <a id='1-5-6-security-fixes'></a> v1.5.6 Security fixes

This release has the following security fixes, listed by component and area.

<table>
<thead>
<tr>
<th>Package Name</th>
<th>Vulnerabilities Resolved</th>
</tr>
</thead>
<tbody>
<tr>
<td>accelerator.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-43642">CVE-2023-43642</a></li>
</ul></details></td>
</tr>
<tr>
<td>api-portal.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-6mjq-h674-j845">GHSA-6mjq-h674-j845</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31484">CVE-2023-31484</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29491">CVE-2023-29491</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
</ul></details></td>
</tr>
<tr>
<td>apis.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31484">CVE-2023-31484</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29491">CVE-2023-29491</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29383">CVE-2023-29383</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26604">CVE-2023-26604</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3821">CVE-2022-3821</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3219">CVE-2022-3219</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-13844">CVE-2020-13844</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2016-2781">CVE-2016-2781</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2013-4235">CVE-2013-4235</a></li>
</ul></details></td>
</tr>
<tr>
<td>apiserver.appliveview.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li>
</ul></details></td>
</tr>
<tr>
<td>application-configuration-service.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-mjmq-gwgm-5qhm">GHSA-mjmq-gwgm-5qhm</a></li>
<li><a href="https://github.com/advisories/GHSA-3p86-9955-h393">GHSA-3p86-9955-h393</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20863">CVE-2023-20863</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20861">CVE-2023-20861</a></li>
</ul></details></td>
</tr>
<tr>
<td>buildservice.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48064">CVE-2022-48064</a></li>
</ul></details></td>
</tr>
<tr>
<td>controller.source.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-6wrf-mxfj-pf5p">GHSA-6wrf-mxfj-pf5p</a></li>
<li><a href="https://github.com/advisories/GHSA-33pg-m6jh-5237">GHSA-33pg-m6jh-5237</a></li>
</ul></details></td>
</tr>
<tr>
<td>conventions.appliveview.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li>
</ul></details></td>
</tr>
<tr>
<td>learningcenter.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48064">CVE-2022-48064</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45919">CVE-2022-45919</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45887">CVE-2022-45887</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-3712">CVE-2021-3712</a></li>
</ul></details></td>
</tr>
<tr>
<td>ootb-templates.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48064">CVE-2022-48064</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45919">CVE-2022-45919</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45887">CVE-2022-45887</a></li>
</ul></details></td>
</tr>
<tr>
<td>policy.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li>
</ul></details></td>
</tr>
<tr>
<td>services-toolkit.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-hp87-p4gw-j4gq">GHSA-hp87-p4gw-j4gq</a></li>
</ul></details></td>
</tr>
<tr>
<td>spring-cloud-gateway.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-cgwf-w82q-5jrr">GHSA-cgwf-w82q-5jrr</a></li>
<li><a href="https://github.com/advisories/GHSA-7g45-4rm6-3mm3">GHSA-7g45-4rm6-3mm3</a></li>
<li><a href="https://github.com/advisories/GHSA-5mg8-w23w-74h3">GHSA-5mg8-w23w-74h3</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42503">CVE-2023-42503</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3635">CVE-2023-3635</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2976">CVE-2023-2976</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22049">CVE-2023-22049</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22045">CVE-2023-22045</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22044">CVE-2023-22044</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22041">CVE-2023-22041</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22036">CVE-2023-22036</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22006">CVE-2023-22006</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-8908">CVE-2020-8908</a></li>
</ul></details></td>
</tr>
<tr>
<td>tap-gui.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32559">CVE-2023-32559</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32006">CVE-2023-32006</a></li>
</ul></details></td>
</tr>
<tr>
<td>tekton.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48566">CVE-2022-48566</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48565">CVE-2022-48565</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48564">CVE-2022-48564</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48560">CVE-2022-48560</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48064">CVE-2022-48064</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45919">CVE-2022-45919</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45887">CVE-2022-45887</a></li>
</ul></details></td>
</tr>
<tr>
<td>workshops.learningcenter.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48064">CVE-2022-48064</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45919">CVE-2022-45919</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45887">CVE-2022-45887</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-3712">CVE-2021-3712</a></li>
</ul></details></td>
</tr>
</tbody>
</table>

---

### <a id='1-5-6-resolved-issues'></a> v1.5.6 Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id='1-5-6-app-config-srvc-ri'></a> v1.5.6 Resolved issues: Application Configuration Service

- Resolves an issue which caused client applications that include the `spring-cloud-config-client`
  dependency to fail to start or properly load the configuration that Application Configuration Service
  produced. The fix is adding the property `spring.cloud.config.enabled=false` in secret resources
  that Application Configuration Service produced.

- Resolves some installation failure scenarios by setting the pod security context to adhere to the
  restricted pod security standard.

---

### <a id='1-5-6-known-issues'></a> v1.5.6 Known issues

This release has the following known issues, listed by component and area.

#### <a id='1-5-6-tap-ki'></a> v1.5.6 Known issues: Tanzu Application Platform

- Tanzu Application Platform v1.5.6 is not supported with Tanzu Kubernetes releases (TKR) v1.26
  on vSphere with Tanzu v8.

---

## <a id='1-5-5'></a> v1.5.5

**Release Date**: 12 September 2023

### <a id='1-5-5-security-fixes'></a> v1.5.5 Security fixes

This release has the following security fixes, listed by component and area.

<table>
<thead>
<tr>
<th>Package Name</th>
<th>Vulnerabilities Resolved</th>
</tr>
</thead>
<tbody>
<tr>
<td>buildservice.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35788">CVE-2023-35788</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3439">CVE-2023-3439</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32233">CVE-2023-32233</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3220">CVE-2023-3220</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31436">CVE-2023-31436</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3117">CVE-2023-3117</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-30456">CVE-2023-30456</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2985">CVE-2023-2985</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2612">CVE-2023-2612</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25012">CVE-2023-25012</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2283">CVE-2023-2283</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1667">CVE-2023-1667</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1380">CVE-2023-1380</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4415">CVE-2022-4415</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3821">CVE-2022-3821</a></li>
</ul></details></td>
</tr>
<tr>
<td>carbonblack.scanning.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-2q89-485c-9j2x">GHSA-2q89-485c-9j2x</a></li>
</ul></details></td>
</tr>
<tr>
<td>eventing.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650 ">CVE-2023-2650 </a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li>
</ul></details></td>
</tr>
<tr>
<td>learningcenter.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-cf7p-gm2m-833m">GHSA-cf7p-gm2m-833m</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4147">CVE-2023-4147</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4015">CVE-2023-4015</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4004">CVE-2023-4004</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3995">CVE-2023-3995</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3777">CVE-2023-3777</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3635">CVE-2023-3635</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3610">CVE-2023-3610</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3609">CVE-2023-3609</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45886">CVE-2022-45886</a></li>
</ul></details></td>
</tr>
<tr>
<td>ootb-templates.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45886">CVE-2022-45886</a></li>
</ul></details></td>
</tr>
<tr>
<td>spring-cloud-gateway.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-41881">CVE-2022-41881</a></li>
</ul></details></td>
</tr>
<tr>
<td>tap-gui.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-cchq-frgv-rjh5">GHSA-cchq-frgv-rjh5</a></li>
<li><a href="https://github.com/advisories/GHSA-g644-9gfx-q4q4">GHSA-g644-9gfx-q4q4</a></li>
</ul></details></td>
</tr>
<tr>
<td>tekton.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45886">CVE-2022-45886</a></li>
</ul></details></td>
</tr>
<tr>
<td>workshops.learningcenter.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4147">CVE-2023-4147</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4015">CVE-2023-4015</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4004">CVE-2023-4004</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3995">CVE-2023-3995</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3777">CVE-2023-3777</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3635">CVE-2023-3635</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3610">CVE-2023-3610</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3609">CVE-2023-3609</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45886">CVE-2022-45886</a></li>
</ul></details></td>
</tr>
</tbody>
</table>

---

### <a id='1-5-5-resolved-issues'></a> v1.5.5 Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id='1-5-5-app-config-serv-ri'></a> v1.5.5 Resolved issues: Application Configuration Service

- `GitRepository` is now consistently observed beyond 15 minutes. The `interval` property for a
  `ConfigurationSlice` now continues to work as expected.

- Error-logging is improved where a `ConfigurationSlice` references a non-existent `ConfigurationSource`.
  A `ConfigurationSlice` properly reconciles after the referenced `ConfigurationSource` is created.

#### <a id='1-5-5-cli-ri'></a> v1.5.5 Resolved issues: Tanzu CLI and plugins

- This release includes Tanzu CLI v1.2.0 and a set of installable plug-in groups that are versioned so
  that the CLI is compatible with every supported version of Tanzu Applicatin Platform.
  For more information, see [Install Tanzu CLI](install-tanzu-cli.hbs.md).

---

### <a id='1-5-5-known-issues'></a> v1.5.5 Known issues

This release has the following known issues, listed by component and area.

#### <a id='1-5-5-tap-ki'></a> v1.5.5 Known issues: Tanzu Application Platform

- Tanzu Application Platform v1.5.5 is not supported with Tanzu Kubernetes releases (TKR) v1.26
  on vSphere with Tanzu v8.

---

## <a id='1-5-4'></a> v1.5.4

**Release Date**: 15 August 2023

### <a id='1-5-4-security-fixes'></a> v1.5.4 Security fixes

This release has the following security fixes, listed by component and area.

<table>
<thead>
<tr>
<th>Package Name</th>
<th>Vulnerabilities Resolved</th>
</tr>
<tr>
<td>carbonblack.scanning.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-g2j6-57v7-gm8c">GHSA-g2j6-57v7-gm8c</a></li>
<li><a href="https://github.com/advisories/GHSA-m8cg-xc2p-r3fc">GHSA-m8cg-xc2p-r3fc</a></li>
</ul></details></td>
</tr>
<tr>
<td>controller.source.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-hw7c-3rfg-p46j">GHSA-hw7c-3rfg-p46j</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
</ul></details></td>
</tr>
<tr>
<td>ootb-templates.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-m8cg-xc2p-r3fc">GHSA-m8cg-xc2p-r3fc</a></li>
<li><a href="https://github.com/advisories/GHSA-hw7c-3rfg-p46j">GHSA-hw7c-3rfg-p46j</a></li>
<li><a href="https://github.com/advisories/GHSA-g2j6-57v7-gm8c">GHSA-g2j6-57v7-gm8c</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3567">CVE-2023-3567</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3358">CVE-2023-3358</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3357">CVE-2023-3357</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32269">CVE-2023-32269</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32233">CVE-2023-32233</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3220">CVE-2023-3220</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3161">CVE-2023-3161</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31484">CVE-2023-31484</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31436">CVE-2023-31436</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-30456">CVE-2023-30456</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2985">CVE-2023-2985</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29491">CVE-2023-29491</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29007">CVE-2023-29007</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28328">CVE-2023-28328</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27538">CVE-2023-27538</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27536">CVE-2023-27536</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27535">CVE-2023-27535</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27534">CVE-2023-27534</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27533">CVE-2023-27533</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26606">CVE-2023-26606</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26545">CVE-2023-26545</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26544">CVE-2023-26544</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2612">CVE-2023-2612</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2603">CVE-2023-2603</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2602">CVE-2023-2602</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25815">CVE-2023-25815</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25652">CVE-2023-25652</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25588">CVE-2023-25588</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25585">CVE-2023-25585</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25584">CVE-2023-25584</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25012">CVE-2023-25012</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23559">CVE-2023-23559</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23455">CVE-2023-23455</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23454">CVE-2023-23454</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2283">CVE-2023-2283</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2162">CVE-2023-2162</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21102">CVE-2023-21102</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20938">CVE-2023-20938</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1998">CVE-2023-1998</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1972">CVE-2023-1972</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1872">CVE-2023-1872</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1859">CVE-2023-1859</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1829">CVE-2023-1829</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1670">CVE-2023-1670</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1667">CVE-2023-1667</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1652">CVE-2023-1652</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1513">CVE-2023-1513</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1380">CVE-2023-1380</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1281">CVE-2023-1281</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1079">CVE-2023-1079</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1078">CVE-2023-1078</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1077">CVE-2023-1077</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1076">CVE-2023-1076</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1075">CVE-2023-1075</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1074">CVE-2023-1074</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1073">CVE-2023-1073</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0459">CVE-2023-0459</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0458">CVE-2023-0458</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0394">CVE-2023-0394</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0386">CVE-2023-0386</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0266">CVE-2023-0266</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0210">CVE-2023-0210</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0045">CVE-2023-0045</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48424">CVE-2022-48424</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48423">CVE-2022-48423</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4842">CVE-2022-4842</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47929">CVE-2022-47929</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4382">CVE-2022-4382</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4129">CVE-2022-4129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-41218">CVE-2022-41218</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3707">CVE-2022-3707</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-36280">CVE-2022-36280</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3424">CVE-2022-3424</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-27672">CVE-2022-27672</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2196">CVE-2022-2196</a></li>
</ul></details></td>
</tr>
<tr>
<td>spring-cloud-gateway.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-crqg-jrpj-fc84">GHSA-crqg-jrpj-fc84</a></li>
<li><a href="https://github.com/advisories/GHSA-6mjq-h674-j845">GHSA-6mjq-h674-j845</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34035">CVE-2023-34035</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34034">CVE-2023-34034</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-33008">CVE-2023-33008</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31484">CVE-2023-31484</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2603">CVE-2023-2603</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2602">CVE-2023-2602</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
</ul></details></td>
</tr>
</table>

---

### <a id='1-5-4-known-issues'></a> v1.5.4 Known issues

This release has the following known issues, listed by component and area.

#### <a id='1-5-4-tap-ki'></a> v1.5.4 Known issues: Tanzu Application Platform

- Upgrading from Tanzu Application Platform v1.4 to v1.5 sometimes causes temporary failures that
  self heal in a few minutes. This is because Tanzu Application Platform switched to versioned secrets
  for all components in v1.5, which can cause a race condition during upgrades and errors similar to
  the following:

      ```console
      Reconcile failed: Preparing template values: secrets "tekton-pipelines-values" not found
      ```

---

## <a id='1-5-3'></a> v1.5.3

**Release Date**: 11 July 2023

### <a id='1-5-3-security-fixes'></a> v1.5.3 Security fixes

This release has the following security fixes, listed by component and area.

<table>
<thead>
<tr>
<th>Package Name</th>
<th>Vulnerabilities Resolved</th>
</tr>
</thead>
<tbody>
<tr>
<td>apis.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li>
</ul></details></td>
</tr>
<tr>
<td>buildservice.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-hw7c-3rfg-p46j">GHSA-hw7c-3rfg-p46j</a></li>
</ul></details></td>
</tr>
<tr>
<td>learningcenter.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2004">CVE-2023-2004</a></li>
</ul></details></td>
</tr>
<tr>
<td>sso.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-m8cg-xc2p-r3fc">GHSA-m8cg-xc2p-r3fc</a></li>
<li><a href="https://github.com/advisories/GHSA-g2j6-57v7-gm8c">GHSA-g2j6-57v7-gm8c</a></li>
<li><a href="https://github.com/advisories/GHSA-f3fp-gc8g-vw66">GHSA-f3fp-gc8g-vw66</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0466">CVE-2023-0466</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3821">CVE-2022-3821</a></li>
</ul></details></td>
</tr>
<tr>
<td>workshops.learningcenter.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2004">CVE-2023-2004</a></li>
</ul></details></td>
</tr>
</tbody>
</table>

---

### <a id='1-5-3-known-issues'></a> v1.5.3 Known issues

This release introduces no new known issues.

---

## <a id='1-5-2'></a> v1.5.2

**Release Date**: 13 June 2023

### <a id='1-5-2-security-fixes'></a> v1.5.2 Security fixes

This release has the following security fixes, listed by component and area.

<table>
<thead>
<tr>
<th>Package Name</th>
<th>Vulnerabilities Resolved</th>
</tr>
</thead>
<tbody>
<tr>
<td>buildservice.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1829">CVE-2023-1829</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1281">CVE-2023-1281</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0386">CVE-2023-0386</a></li>
</ul></details></td>
</tr>
<tr>
<td>cert-manager.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-vvpx-j8f3-3w6h">GHSA-vvpx-j8f3-3w6h</a></li>
</ul></details></td>
</tr>
<tr>
<td>sso.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31484">CVE-2023-31484</a></li>
</ul></details></td>
</tr>
<tr>
<td>tap-gui.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-f9xv-q969-pqx4">GHSA-f9xv-q969-pqx4</a></li>
</ul></details></td>
</tr>
</tbody>
</table>

---

### <a id='1-5-2-resolved-issues'></a> v1.5.2 Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id='1-5-2-scst-scan-ri'></a> v1.5.2 Resolved issues: Supply Chain Security Tools (SCST) - Scan

- Old `TaskRuns` associated with scans are now deleted to reduce memory consumption.
- Added support for `ConfigMaps` in custom `ScanTemplates`.

#### <a id='1-5-2-tap-gui-ri'></a> v1.5.2 Resolved issues: Tanzu Application Platform GUI

- Simplified the default content security policy to remove violations from `fonts.googleapis.com`.

#### <a id="1-5-2-tap-gui-plug-in-ri"></a> v1.5.2 Resolved issues: Tanzu Application Platform GUI plug-ins

- **Security Analysis GUI plug-in:**
  - **CVE Details:** The impacted workload count in the widget now matches the table.
  - **Security Analysis Dashboard:** The Highest Reach Critical Vulnerabilities chart no longer
    overlaps Snyk CVE IDs.
  - **Package Details:** Removed extra versions from Workload Builds using Package table.

#### <a id='1-5-2-intellij-ext-ri'></a> v1.5.2 Resolved issues: Tanzu Developer Tools for IntelliJ

- Resolved permission-denied errors encountered during Live Update when operating against platforms
  configured to use the Jammy build stack.

#### <a id='1-5-2-vs-ext-ri'></a> v1.5.2 Resolved issues: Tanzu Developer Tools for Visual Studio

- Resolved permission-denied errors encountered during Live Update when operating against platforms
  configured to use the Jammy build stack.

#### <a id='1-5-2-vscode-ext-ri'></a> v1.5.2 Resolved issues: Tanzu Developer Tools for VS Code

- Resolved permission-denied errors encountered during Live Update when operating against platforms
  configured to use the Jammy build stack.

---

### <a id='1-5-2-known-issues'></a> v1.5.2 Known issues

This release introduces no new known issues.

---

## <a id='1-5-1'></a> v1.5.1

**Release Date**: 09 May 2023

### <a id='1-5-1-security-fixes'></a> v1.5.1 Security fixes

This release has the following security fixes, listed by component and area.

<table>
<thead>
<tr>
<th>Package Name</th>
<th>Vulnerabilities Resolved</th>
</tr>
</thead>
<tbody>
<tr>
<td>accelerator.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20860">CVE-2023-20860</a></li>
</ul></details></td>
</tr>
<tr>
<td>api-portal.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20860">CVE-2023-20860</a></li><li>GHSA-493p-pfq6-5258 </li>
</ul></details></td>
</tr>
<tr>
<td>application-configuration-service.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20860">CVE-2023-20860</a></li>
</ul></details></td>
</tr>
<tr>
<td>apiserver.appliveview.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-vvpx-j8f3-3w6h">GHSA-vvpx-j8f3-3w6h</a></li>
<li><a href="https://github.com/advisories/GHSA-r48q-9g5r-8q2h">GHSA-r48q-9g5r-8q2h</a></li>
</ul></details></td>
</tr>
<tr>
<td>app-scanning.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-gwc9-m7rh-j2ww">GHSA-gwc9-m7rh-j2ww</a></li>
<li><a href="https://github.com/advisories/GHSA-fxg5-wq6x-vr4w">GHSA-fxg5-wq6x-vr4w</a></li>
<li><a href="https://github.com/advisories/GHSA-8c26-wmh5-6g9v">GHSA-8c26-wmh5-6g9v</a></li>
<li><a href="https://github.com/advisories/GHSA-69cg-p879-7622">GHSA-69cg-p879-7622</a></li>
<li><a href="https://github.com/advisories/GHSA-3vm4-22fp-5rfm">GHSA-3vm4-22fp-5rfm</a></li>
</ul></details></td>
</tr>
<tr>
<td>backend.appliveview.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-mjmj-j48q-9wg2">GHSA-mjmj-j48q-9wg2</a></li>
<li><a href="https://github.com/advisories/GHSA-36p3-wjmg-h94x">GHSA-36p3-wjmg-h94x</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20860">CVE-2023-20860</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-41881">CVE-2022-41881</a></li>
</ul></details></td>
</tr>
<tr>
<td>buildservice.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-vvpx-j8f3-3w6h">GHSA-vvpx-j8f3-3w6h</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20860">CVE-2023-20860</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0461">CVE-2023-0461</a></li>
</ul></details></td>
</tr>
<tr>
<td>carbonblack.scanning.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-vvpx-j8f3-3w6h">GHSA-vvpx-j8f3-3w6h</a></li>
<li><a href="https://github.com/advisories/GHSA-vpvm-3wq2-2wvm">GHSA-vpvm-3wq2-2wvm</a></li>
<li><a href="https://github.com/advisories/GHSA-gwc9-m7rh-j2ww">GHSA-gwc9-m7rh-j2ww</a></li>
<li><a href="https://github.com/advisories/GHSA-fxg5-wq6x-vr4w">GHSA-fxg5-wq6x-vr4w</a></li>
<li><a href="https://github.com/advisories/GHSA-8c26-wmh5-6g9v">GHSA-8c26-wmh5-6g9v</a></li>
<li><a href="https://github.com/advisories/GHSA-69ch-w2m2-3vjp">GHSA-69ch-w2m2-3vjp</a></li>
<li><a href="https://github.com/advisories/GHSA-69cg-p879-7622">GHSA-69cg-p879-7622</a></li>
<li><a href="https://github.com/advisories/GHSA-3vm4-22fp-5rfm">GHSA-3vm4-22fp-5rfm</a></li>
</ul></details></td>
</tr>
<tr>
<td>connector.appliveview.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-mjmj-j48q-9wg2">GHSA-mjmj-j48q-9wg2</a></li>
<li><a href="https://github.com/advisories/GHSA-36p3-wjmg-h94x">GHSA-36p3-wjmg-h94x</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20860">CVE-2023-20860</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-41881">CVE-2022-41881</a></li>
</ul></details></td>
</tr>
<tr>
<td>learningcenter.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-hc6q-2mpp-qw7j">GHSA-hc6q-2mpp-qw7j</a></li>
<li><a href="https://github.com/advisories/GHSA-frjg-g767-7363">GHSA-frjg-g767-7363</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26114">CVE-2023-26114</a></li>
</ul></details></td>
</tr>
<tr>
<td>metadata-store.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-vvpx-j8f3-3w6h">GHSA-vvpx-j8f3-3w6h</a></li>
</ul></details></td>
</tr>
<tr>
<td>ootb-templates.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-vvpx-j8f3-3w6h">GHSA-vvpx-j8f3-3w6h</a></li>
</ul></details></td>
</tr>
<tr>
<td>scanning.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-vvpx-j8f3-3w6h">GHSA-vvpx-j8f3-3w6h</a></li>
</ul></details></td>
</tr>
<tr>
<td>snyk.scanning.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-rc47-6667-2j5j">GHSA-rc47-6667-2j5j</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23919">CVE-2023-23919</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23918">CVE-2023-23918</a></li>
</ul></details></td>
</tr>
<tr>
<td>spring-cloud-gateway.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-493p-pfq6-5258">GHSA-493p-pfq6-5258</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20860">CVE-2023-20860</a></li>
</ul></details></td>
</tr>
<tr>
<td>sso.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0466">CVE-2023-0466</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4899">CVE-2022-4899</a></li>
</ul></details></td>
</tr>
<tr>
<td>tap-gui.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0466">CVE-2023-0466</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4899">CVE-2022-4899</a></li>
</ul></details></td>
</tr>
<tr>
<td>workshops.learningcenter.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-frjg-g767-7363">GHSA-frjg-g767-7363</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26114">CVE-2023-26114</a></li>
</ul></details></td>
</tr>
</tbody>
</table>

---

### <a id='1-5-1-resolved-issues'></a> v1.5.1 Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id='1-5-1-app-acc-ri'></a> v1.5.1 Resolved issues: Application Accelerator

- The IntelliJ plug-in can now be installed in IntelliJ v2023.1.

#### <a id="1-5-1-external-secrets-ri"></a> v1.5.1 Resolved issues: External Secrets CLI (beta)

- The external-secrets plug-in creating the `ExternalSecret` and `SecretStore` resources through stdin
  now correctly confirms resource creation. Use `-f ` to create resources using a file instead of stdin.

#### <a id='1-5-1-intellij-ext-ri'></a> v1.5.1 Resolved issues: Tanzu Developer Tools for IntelliJ

- Live Update now works when using the Jammy `ClusterBuilder`.

#### <a id='1-5-1-vs-ext-ri'></a> v1.5.1 Resolved issues: Tanzu Developer Tools for Visual Studio

- Live Update now works when using the Jammy `ClusterBuilder`.

---

### <a id='1-5-1-known-issues'></a> v1.5.1 Known issues

This release has the following known issues, listed by component and area.

#### <a id='1-5-1-scst-scan-ki'></a> v1.5.1 Known issues: Supply Chain Security Tools (SCST) - Scan

- `TaskRuns` associated with scans are kept during the lifetime of the owner scan.
  This can lead to Out of Memory restart problems in the SCST - Scan controller.

- `ConfigMaps` used in `ScanTemplates` are not supported, whether introduced by overlays or in a
  custom `ScanTemplate`. This is the error message you see:

    ```console
    The scan job could not be created. admission webhook "validation.webhook.pipeline.tekton.dev" denied the request: validation failed: expected exactly one, got neither: spec.workspaces[5].configmap, spec.workspaces[5].emptydir, spec.workspaces[5].persistentvolumeclaim, spec.workspaces[5].secret, spec.workspaces[5].volumeclaimtemplate
    ```

#### <a id='1-5-1-tap-gui-ki'></a> v1.5.1 Known issues: Tanzu Application Platform GUI

- Ad-blocking browser extensions and standalone ad-blocking software can interfere with telemetry
  collection within the VMware
  [Customer Experience Improvement Program](https://www.vmware.com/solutions/trustvmware/ceip.html)
  and restrict access to all or parts of Tanzu Application Platform GUI.
  For more information, see [Troubleshooting](tap-gui/troubleshooting.hbs.md#ad-block-interference).

---

## <a id='1-5-0'></a> v1.5.0

**Release Date**: 11 April 2023

### <a id='1-5-0-whats-new'></a> What's new in Tanzu Application Platform

This release includes the following platform-wide enhancements.

#### <a id='1-5-0-new-components'></a> v1.5.0 New components

- [Application Configuration Service](application-configuration-service/about.hbs.md) is a new component
  that provides a Kubernetes-native experience to enable the runtime
  configuration of existing Spring applications that were previously leveraged by using
  Spring Cloud Config Server.

- [Crossplane](crossplane/about.hbs.md) is a new component that powers a number of capabilities,
  such as dynamic provisioning of service instances with Services Toolkit and the
  Bitnami Services. It is part of the iterate, run, and full profiles.

- [Bitnami Services](bitnami-services/about.hbs.md) is a new component that includes a set of
  backing services for Tanzu Application Platform.
  The provided services are MySQL, PostgreSQL, RabbitMQ and Redis, all of which are backed by
  the corresponding Bitnami Helm Chart. It is part of the iterate, run, and full profiles.

- [Spring Cloud Gateway](spring-cloud-gateway/about.hbs.md) is an API gateway solution based on
  the open-source Spring Cloud Gateway project.
  This new component provides a simple means to route internal or external API requests
  to application services that expose APIs.

### <a id='1-5-0-new-features'></a> v1.5.0 New features by component and area

This release includes the following changes, listed by component and area.

#### <a id='1-5-0-app-acc-features'></a> v1.5.0 Features: Application Accelerator

- The Application Accelerator plug-in for IntelliJ is now available as a beta release on
  [Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform/).

- Adds the option to support Spring Boot v3.0 for the
  [Tanzu Java Restful Web App](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/java-rest-service)
  and [Tanzu Java Web App](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/tanzu-java-web-app) accelerators.

- Application Accelerator now generates application bootstrapping provenance when a project is created using an accelerator. For more information, see [Provenance transform](application-accelerator/creating-accelerators/transforms/provenance.hbs.md).

- Adds the option to use a system-wide property in the `tap-values.yaml` configuration file to activate or
  deactivate Git repository creation. For more information, see [Deactivate Git repository creation](tap-gui/plugins/application-accelerator-git-repo.hbs.md#deactiv-git-repo-creation).

- The Accelerator Tanzu CLI plug-in now supports using the Tanzu Application Platform GUI URL
  with the `--server-url` command option.
  For more information, see [Using Tanzu Application Platform GUI URL](cli-plugins/accelerator/overview.html#server-api-tap-gui)

#### <a id='1-5-0-app-live-view'></a> v1.5.0 Features: Application Live View

- Application Live View now supports improved security and access control.
  Introduces the `APIServer` component that generates and validates user access to view actuator data for a pod.
  For more information, see [Improved security and access control in Application Live View](app-live-view/improved-security-and-access-control.hbs.md).

- Application Live View now supports secure access to sensitive operations that can be executed on a running application using the actuator endpoints at the cluster level.
  For more information, see [Improved security and access control in Application Live View](app-live-view/improved-security-and-access-control.hbs.md)

- The Application Live View plugin now supports CPU stats in the memory and threads pages for Steeltoe Applications.
  For more information, see
  [Application Live View for Steeltoe Applications in Tanzu Application Platform GUI](tap-gui/plugins/app-live-view-steeltoe.hbs.md).

#### <a id='1-5-0-app-sso-features'></a> v1.5.0 Features: Application Single Sign-On (AppSSO)

- Introduces `AuthServer` CORS API that enables configuration of allowed HTTP origins.
  This is useful for public clients, such as single-page apps.

- Introduces an API for filtering external roles, groups, and memberships across OpenID, LDAP, and SAML
  identity providers in `AuthServer` resource into the `roles` claim of the resulting identity
  token. For more information, see [Roles claim filtering](app-sso/service-operators/identity-providers.hbs.md#roles-filters).

- Introduces mapping of user roles, filtered and propagated in the identity
  token's `roles` claim, into scopes of the access token.
  For access tokens that are in the JWT format, the resulting scopes are part of the access token's
  `scope` claim, if the `ClientRegistration` contains the scopes.
  For more information, see [Configure authorization](app-sso/service-operators/configure-authorization.hbs.md).

- Introduces default access token scopes for user's authentication by using an identity
  provider. For more information, see [Default authorization scopes](app-sso/service-operators/configure-authorization.hbs.md#default-scopes).

- Introduces standardized client authentication methods to `ClientRegistration` custom resource.
  For more information, see [ClientRegistration](app-sso/crds/clientregistration.hbs.md).

#### <a id='1-5-0-bitnami-services-features'></a> v1.5.0 Features: Bitnami Services

- The new component [Bitnami Services](bitnami-services/about.hbs.md) is available with
  Tanzu Application Platform.

- Provides integration for dynamic provisioning of Bitnami Helm Charts included with
  Tanzu Application Platform for the following backing services:
   - PostgreSQL
   - MySQL
   - Redis
   - RabbitMQ

   For a tutorial to get started with using these services, see [Working with Bitnami Services](services-toolkit/tutorials/working-with-bitnami-services.hbs.md).


#### <a id='1-5-0-cert-manager-ncf'></a> v1.5.0 Features: cert-manager

- `cert-manager.tanzu.vmware.com` has upgraded to cert-manager v1.11.0.
  For more information, see [cert-manager GitHub repository](https://github.com/cert-manager/cert-manager/releases/tag/v1.11.0).

#### <a id='1-5-0-crossplane-features'></a> v1.5.0 Features: Crossplane

- The new component [Crossplane](crossplane/about.hbs.md) is available with Tanzu Application Platform.
  It installs [Upbound Universal Crossplane](https://github.com/upbound/universal-crossplane) v1.11.0.

- Provides integration for dynamic provisioning in Services Toolkit and can be used for
  integration with cloud services such as AWS, Azure, and GCP.
  For more information, see
  [Integrating cloud services into Tanzu Application Platform](services-toolkit/tutorials/integrate-cloud-services.hbs.md).

  For more information about dynamic provisioning, see
  [Set up dynamic provisioning of service instances](services-toolkit/tutorials/setup-dynamic-provisioning.hbs.md) to learn more.

- Includes two Crossplane [Providers](https://docs.crossplane.io/latest/concepts/providers/):
  `provider-kubernetes` and `provider-helm`.
  You can add other providers manually as required.

#### <a id='1-5-0-external-secrets-features'></a> v1.5.0 Features: External Secrets CLI (Beta)

- The external-secrets plug-in available in the Tanzu CLI interacts with the External Secrets Operator API.
  Users can use this CLI plug-in to create and view External Secrets Operator resources on a Kubernetes cluster.

   For more information about managing secrets with External Secrets in general, see the official [External Secrets Operator documentation](https://external-secrets.io).
   For installing the External Secrets Operator and the CLI plug-in, see the following documentation:

   - [Installing External Secrets Operator in TAP](external-secrets/install-external-secrets-operator.hbs.md)
   - [Installing External Secrets CLI plug-in](prerequisites.hbs.md)
   - [External-Secrets with Hashicorp Vault](external-secrets/vault-example.md)

   Additionally, see the example integration of External-Secrets with Hashicorp Vault

#### <a id="1-5-namespace-provisioner-feats"></a> v1.5.0 Features: Namespace Provisioner

- Includes a new GitOps workflow for managing a list of namespaces fully declaratively
  through a Git repository. Specify the location of the GitOps repository that has the list of namespaces
  that you want as ytt data values to be imported in the namespace provisioner using the `gitops_install` `tap-values.yaml` configuration.

   For more information, see the GitOps section in
   [Provision developer namespaces](namespace-provisioner/provision-developer-ns.md).

- The Namespace Provisioner controller supports adding namespace parameters from labels or annotations
  on namespace objects based on accepted prefixes defined in the `parameter_prefixes` configuration in the `tap-values.yaml`.
  You can use this feature to add custom parameters to a namespace for creating resources conditionally.

   For an example, see
   [Create Tekton pipelines and Scan policies using namespace parameters](namespace-provisioner/use-case2.md).

- Adds support for importing Kubernetes secrets that contain a ytt overlay definition that you can apply
  to the resources that Namespace Provisioner creates.

   Using the `overlays_secret` configuration in namespace provisioner `tap-values.yaml`,
   you can provide a list of secrets that contain the overlay definition to apply
   to resources created by provisioner.

   For an example of using overlays, see
   [Customize OOTB default resources](namespace-provisioner/use-case4.md).

- Adds support for reading sensitive data from a Kubernetes secret in YAML format and populating that
  information in the resources that Namespace Provisioner creates during runtime.
  This is kept in sync with the source. This removes the need to store any sensitive data in GitOps repository.
  - Using the `import_data_values_secrets` configuration in the Namespace Provisioner section of the Tanzu Application Platform values file, you can
   import sensitive data from a YAML formatted secret and make it available under `data.values.imported` for additional resource templating.
  - For an example use case, see
    [Install multiple scanners in the developer namespace](./namespace-provisioner/use-case5.md).

- Namespace Provisioner now creates a Kubernetes `LimitRange` object with acceptable default values that set
  maximum limits on many resources that pods in the managed namespace can request.
   - Run profile: Stamped by default.
   - Full and iterate profile: Opt-in using parameters.

   For a sample configuration, see [Customize OOTB Limit Range default](./namespace-provisioner/use-case4.md#customize-limit-range-defaults).

- Namespaces Provisioner enables you to use private Git repositories for storing their GitOps based
  installation files and additional platform operator templated resources that you want to create
  in your developer namespace. Authentication is provided using a secret in `tap-namespace-provisioning`
  namespace, or an existing secret in another namespace referred to in the `secretRef` in the additional sources.

   For an example use case, see [Working with private Git Repositories](./namespace-provisioner/use-case3.md)

#### <a id='1-5-0-services-toolkit-features'></a> v1.5.0 Features: Services Toolkit

- Services Toolkit now supports the dynamic provisioning of services instances.
  - `ClusterInstanceClass` now supports the new provisioner mode.
  When a `ClassClaim` is created which refers to a provisioner `ClusterInstanceClass`, a new
  service instance is created on-demand and claimed. This is powered by [Crossplane](crossplane/about.hbs.md).

- The `tanzu service` CLI plug-in has the following updates:
   - The command `tanzu service class-claim create`  now allows you to pass parameters to the
   provisioner-based `ClusterInstanceClass` to support dynamic provisioning.
   For example,
   `tanzu service class-claim create rmq-claim-1 --class rmq --parameter replicas=3  --parameter ha=true`
   - The `tanzu service class-claim get` now outputs parameters passed as part of claim creation.

   For more information about these commands, see [Tanzu Service CLI Plug-In](services-toolkit/reference/tanzu-service-cli.hbs.md#stk-cli-class-claim).

- Integrates with the new component [Bitnami Services](bitnami-services/about.hbs.md),
  which provides dynamic provisioning support for the following Helm charts:
   - PostgreSQL
   - MySQL
   - Redis
   - RabbitMQ

- Improves the security model to control which users can claim specific service instances.
   - Introduced the `claim` custom RBAC verb that targets a specific `ClusterInstanceClass`.
   You can bind this to users for access control of who can create `ClassClaim` resources for
   a specific `ClusterInstanceClass`.
   - A `ResourceClaimPolicy` is now created automatically for successful `ClassClaims`.

   For more information, see [Authorize users and groups to claim from provisioner-based classes](services-toolkit/how-to-guides/authorize-claim-provisioner-classes.hbs.md) to learn more.

- The `ResourceClaimPolicy` now supports targeting individual resources by name.
  To do so, configure `.spec.subject.resourceNames`.

- The `Where-For-Dinner` sample Application Accelerator now supports dynamic provisioning.

- Changes to the Services Toolkit component documentation.
   - The [standalone Services Toolkit documentation](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/index.html)
   is no longer receiving updates.
   From now on you can find all Services Toolkit documentation in the Tanzu Application Platform
   component documentation section for [Services Toolkit](services-toolkit/about.hbs.md).
   - To learn more about working with services on Tanzu Application Platform, see the new
   [tutorials](services-toolkit/tutorials/index.hbs.md),
   [how-to guides](services-toolkit/how-to-guides/index.hbs.md),
   [concepts](services-toolkit/concepts/index.hbs.md), and
   [reference material](services-toolkit/reference/index.hbs.md).

#### <a id='1-5-0-scc-features'></a> v1.5.0 Features: Supply Chain Choreographer

- Introduces a variation of the Out of the Box Basic supply chains that output Carvel packages.
  Carvel packages enable configuring for each runtime environment.
  For more information, see [Carvel Package Workflow](scc/carvel-package-supply-chain.hbs.md).
  This feature is experimental.

#### <a id='1-5-0-scst-policy-features'></a> v1.5.0 Features: Supply Chain Security Tools (SCST) - Policy Controller

- ClusterImagePolicy resync is triggered every 10 hours to get updated values from the Key Management Service (KMS).

#### <a id="1-5-0-scst-scan-features"></a> v1.5.0 Features: Supply Chain Security Tools (SCST) - Scan

- SCST - Scan now runs on Tanzu Service Mesh-enabled clusters, enabling end to end, secure communication.
   - Kubernetes jobs that previously created the scan pods were replaced with [Tekton TaskRuns](https://tekton.dev/docs/pipelines/taskruns/#overview).
   - [Observability](./scst-scan/observing.hbs.md) and [Troubleshooting](./scst-scan/troubleshoot-scan.hbs.md) documentation is updated to account for the impact of these changes. For successful scans, scanner pods restart once. For more information, see [Scanner pod restarts once in SCST - Scan v1.5.0 or later](./scst-scan/troubleshoot-scan.hbs.md#scanner-pod-restarts).

- Adds support for rotating certificates and TLS, to conform with NIST 800-53. Users can specify a TLS certificate, minimum TLS version, and restrict TLS ciphers when using kube-rbac-proxy.
For more information, see [Configure properties](./scst-scan/install-scst-scan.hbs.md#configure-scst-scan).

- SCST - Scan now offers even more flexibility for users to use their existing investments in scanning solutions. In Tanzu Application Platform v1.5.0, users have early access to:
   - A new alpha integration with the [Trivy Open Source Vulnerability Scanner](https://www.aquasec.com/products/trivy/) by Aqua Security that scans source code and images from secure supply chains. See [Install Trivy (alpha)](./scst-scan/install-trivy-integration.hbs.md).
   - A simplified alpha user experience for creating custom integrations with additional vulnerability scanners that are not included by default. If you have a scanner that you would like to use with Tanzu Application Platform, see [SCST - Scan 2.0 (alpha)](./scst-scan/app-scanning-alpha.hbs.md).
   - VMware is looking for early adopters to test both of these alpha offerings and provide feedback. Email your Tanzu representative or [contact us here](https://tanzu.vmware.com/application-platform).

- Carbon Black integration is updated to use the Carbon Black scanner CLI v1.9.2.
  Notable optimizations include improved scan logic that reduces the time it takes for a scan to complete.

   For more information, see the [Carbon Black Cloud Console Release Notes](https://docs.vmware.com/en/VMware-Carbon-Black-Cloud/services/rn/vmware-carbon-black-cloud-console-release-notes/index.html#What's%20New%20-%2012%20January%202023-Container%20Essentials).

#### <a id='1-5-0-tap-gui-features'></a> v1.5.0 Features: Tanzu Application Platform GUI

- **Disclosure:** This upgrade includes a Java script operated by the service provider Pendo.io.
  The Java script is installed on selected pages of VMware software and collects information about
  your use of the software, such as clickstream data and page loads, hashed user ID, and limited
  browser and device information.
  VMware uses this information to better understand the way you use the software to improve
  your experience with VMware products and services.
  For more information, see the
  [Customer Experience Improvement Program](https://www.vmware.com/solutions/trustvmware/ceip.html).

- Supports automatic configuration with SCST - Store. For more information,
  see [Automatically connect Tanzu Application Platform GUI to the Metadata Store](tap-gui/plugins/scc-tap-gui.hbs.md#scan-auto).

- Enables specification of security banners. To use this customization,
  see [Customize security banners](tap-gui/customize/customize-portal.hbs.md#cust-security-banners).

- Upgrades Backstage to v1.10.1.

- Includes an optional plug-in that collects telemetry by using the Pendo tool.
  To configure Pendo telemetry and opt in or opt out, see
  [Opt out of telemetry collection](opting-out-telemetry.hbs.md).

#### <a id="tap-gui-plug-in-features"></a> v1.5.0 Features: Tanzu Application Platform GUI plug-ins

- **Application Live View plug-in:**
  - When `alvToken` has expired, the logic to fetch a new token and the API call are both retried.
  - Actions are deactivated and a message is displayed when sensitive operations are deactivated for
    the app.
  - The **Heap Dump** button deactivates when sensitive operations are deactivated for the application.
  - Enabled Secure Access Communication between App Live View components.
  - Added an API to connect to `appliveview-apiserver` by reusing `tap-gui` authentication.
  - The Application Live View plug-in now requests a token from `appliveview-apiserver` and passes it
    to every call to the Application Live View back end.
  - Provides secured sensitive operations (edit env, change log levels, download heap dump) and
    displays a message in the UI.
  - Renamed the `k8s-logging-backend` plug-in as `k8s-custom-apis-backend`.
  - The fetch token for the `logLevelsPanelToggle` component is now loaded from the workload plug-in
    PodLogs page.

- **Security Analysis GUI plug-in:**
  - **CVE Details:** Added Impacted Workloads widget to the CVE Details page.
  - **CVE Details:** Display and navigate to latest source SHA or image digest in the Workload Builds
    table.
  - **Package Details:** Added Impacted Workloads column to the Vulnerabilities table.
  - **Package Details:** Display and navigate to latest source SHA or image digest in the Workload
    Builds table.
  - **Security Analysis Dashboard:** Added Highest Reach Vulnerabilities widget.

#### <a id="1-5-0-apps-plugin-features"></a> v1.5.0 Features: Tanzu CLI Apps plug-in

- Adds support for `-ojson` and `-oyaml` output flags in `tanzu apps workload create/apply` command.
  The CLI does not wait to print workload when using `--output` in workload create/apply unless
  `--wait` or `--tail` flags are specified as well.

- Using the `--no-color` flag in `tanzu apps workload create/apply` commands now hides progress bars
  in addition to color output and emojis.

- Adds support for unsetting `--git-repo`, `--git-commit`, `--git-tag` and `--git-branch` flags
  by setting the value to empty string.

#### <a id='1-5-0-intellij-feats'></a> v1.5.0 Features: Tanzu Developer Tools for IntelliJ

- Updates the Tanzu Workloads panel to show workloads deployed across multiple namespaces.

- Tanzu actions for `workload apply`, `workload delete`, `debug`, and `Live Update start` are now
  available from the Tanzu Workloads panel.

- You can use Tanzu Developer Tools for IntelliJ to iterate on Spring Boot 3-based applications.

#### <a id='1-5-0-vs-plugin-feats'></a> v1.5.0 Features: Tanzu Developer Tools for Visual Studio

- Supports iterative development of applications consisting of multiple microservices, enabling
  developers to debug and Live Update each microservice independently and simultaneously.

- Enables existing projects to work with Tanzu Application Platform developer tools easily by
  using templates to generate the necessary configuration files.

#### <a id='1-5-0-vscode-plugin-feats'></a> v1.5.0 Features: Tanzu Developer Tools for VS Code

- The Tanzu Activity tab in the Panels view enables developers to visualize the supply chain, delivery,
  and running application pods.

  The tab enables a developer to view and describe logs on each resource associated with a workload
  from within their IDE. The tab displays detailed error messages for each resource in an error state.

- Updates the Tanzu Workloads panel to show workloads deployed across multiple namespaces.

- Tanzu commands for `workload apply`, `workload delete`, `debug`, and `Live Update start` are now
  available from the Tanzu Workloads panel.

- You can use Tanzu Developer Tools for VS Code to iterate on Spring Boot 3-based applications.

---

### <a id='1-5-0-breaking-changes'></a> v1.5.0 Breaking changes

This release has the following breaking changes, listed by area and component.

#### <a id='1-5-0-convention-controller-bc'></a> v1.5.0 Breaking changes: Convention Controller

- Convention Controller is removed in this release and is replaced by
  [Cartographer Conventions](https://github.com/vmware-tanzu/cartographer-conventions).
  Cartographer Conventions implements the `conventions.carto.run` API that includes all the features
  that were available in the Convention Controller component.

#### <a id="1-5-0-scst-scan-bc"></a> v1.5.0 Breaking changes: Supply Chain Security Tools (SCST) - Scan

- The deprecated Grype ScanTemplates included with Tanzu Application Platform v1.2.0 and earlier are removed
  and no longer supported. Use Grype ScanTemplates v1.2 and later.

#### <a id='1-5-0-tbs-bc'></a> v1.5.0 Breaking changes: Tanzu Build Service

- The default `ClusterBuilder` now uses the Ubuntu Jammy v22.04 stack instead of the Ubuntu Bionic
  v18.04 stack. Previously, the default `ClusterBuilder` pointed to the Base builder based on the
  Bionic stack. Now, the default `ClusterBuilder` points to the Base builder based on the Jammy stack.
  Ensure that your workloads can be built and run on Jammy.

   For information about how to change the `ClusterBuilder` from the default builder, see the
   [Configure the Cluster Builder](tanzu-build-service/tbs-workload-config.hbs.md#cluster-builder).

   For more information about available builders, see
   [Lite Dependencies](../docs-tap/tanzu-build-service/dependencies.hbs.md#lite-dependencies) and
   [Full Dependencies](../docs-tap/tanzu-build-service/dependencies.hbs.md#full-dependencies).

- The Tanzu Build Service automatic dependency updater feature is removed in
  Tanzu Application Platform v1.5.0.
  This feature has been deprecated since Tanzu Application Platform v1.2.

---

### <a id='1-5-0-security-fixes'></a> v1.5.0 Security fixes

This release has the following security fixes, listed by area and component.

<table>
<thead>
<tr>
<th>Package Name</th>
<th>Vulnerabilities Resolved</th>
</tr>
</thead>
<tbody>
<tr>
<td>buildservice.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-fxg5-wq6x-vr4w">GHSA-fxg5-wq6x-vr4w</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0179">CVE-2023-0179</a></li>
</ul></details></td>
</tr>
<tr>
<td>carbonblack.scanning.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24827">CVE-2023-24827</a></li>
</ul></details></td>
</tr>
<tr>
<td>eventing.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-fxg5-wq6x-vr4w">GHSA-fxg5-wq6x-vr4w</a></li>
<li><a href="https://github.com/advisories/GHSA-69ch-w2m2-3vjp">GHSA-69ch-w2m2-3vjp</a></li>
<li><a href="https://github.com/advisories/GHSA-69cg-p879-7622">GHSA-69cg-p879-7622</a></li>
</ul></details></td>
</tr>
<tr>
<td>grype.scanning.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24329">CVE-2023-24329</a></li>
</ul></details></td>
</tr>
<tr>
<td>learningcenter.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-x4qr-2fvf-3mr5">GHSA-x4qr-2fvf-3mr5</a></li>
<li><a href="https://github.com/advisories/GHSA-ppp9-7jff-5vj2">GHSA-ppp9-7jff-5vj2</a></li>
<li><a href="https://github.com/advisories/GHSA-fxg5-wq6x-vr4w">GHSA-fxg5-wq6x-vr4w</a></li>
<li><a href="https://github.com/advisories/GHSA-83g2-8m93-v3w7">GHSA-83g2-8m93-v3w7</a></li>
<li><a href="https://github.com/advisories/GHSA-69ch-w2m2-3vjp">GHSA-69ch-w2m2-3vjp</a></li>
<li><a href="https://github.com/advisories/GHSA-3vm4-22fp-5rfm">GHSA-3vm4-22fp-5rfm</a></li>
<li><a href="https://github.com/advisories/GHSA-2hrw-hx67-34x6">GHSA-2hrw-hx67-34x6</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24329">CVE-2023-24329</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23919">CVE-2023-23919</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0461">CVE-2023-0461</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0286">CVE-2023-0286</a></li>
</ul></details></td>
</tr>
<tr>
<td>policy.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-fxg5-wq6x-vr4w">GHSA-fxg5-wq6x-vr4w</a></li>
</ul></details></td>
</tr>
<tr>
<td>snyk.scanning.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24329">CVE-2023-24329</a></li>
</ul></details></td>
</tr>
<tr>
<td>tap-gui.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23919">CVE-2023-23919</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23918">CVE-2023-23918</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0361">CVE-2023-0361</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0286">CVE-2023-0286</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0215">CVE-2023-0215</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4450">CVE-2022-4450</a></li>
</ul></details></td>
</tr>
<tr>
<td>workshops.learningcenter.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-ppp9-7jff-5vj2">GHSA-ppp9-7jff-5vj2</a></li>
<li><a href="https://github.com/advisories/GHSA-fxg5-wq6x-vr4w">GHSA-fxg5-wq6x-vr4w</a></li>
<li><a href="https://github.com/advisories/GHSA-83g2-8m93-v3w7">GHSA-83g2-8m93-v3w7</a></li>
<li><a href="https://github.com/advisories/GHSA-69ch-w2m2-3vjp">GHSA-69ch-w2m2-3vjp</a></li>
<li><a href="https://github.com/advisories/GHSA-3vm4-22fp-5rfm">GHSA-3vm4-22fp-5rfm</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24329">CVE-2023-24329</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23919">CVE-2023-23919</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0461">CVE-2023-0461</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0286">CVE-2023-0286</a></li>
</ul></details></td>
</tr>
</tbody>
</table>

>**Note** CVE-2023-0179, CVE-2023-1281 and CVE-2023-0461 are high severity vulnerabilities.
>At this time, there is no available patch for them upstream for some Tanzu Application Platform components.
>After there is a patch available, Tanzu Application Platform will release a patched base stack image.
>These vulnerabilities are kernel exploits that run on your container host VM, not the Tanzu Application Platform container image.
>Running on an up to date kernel is a mitigation for these vulnerabilities.

---

### <a id='1-5-0-resolved-issues'></a> v1.5.0 Resolved issues

The following issues, listed by area and component, are resolved in this release.

#### <a id='1-5-0-app-acc-ri'></a> v1.5.0 Resolved issues: Application Accelerator

- Resolved issue with `custom types` not re-ordering fields correctly in the VS Code extension.

#### <a id='1-5-0-app-sso-ri'></a> v1.5.0 Resolved issues: Application Single Sign-On (AppSSO)

- Resolved redirect URI issue with insecure HTTP redirection on Tanzu Kubernetes Grid multicloud
(TKGm) clusters.

#### <a id='1-5-0-cnrs-ri'></a> v1.5.0 Resolved issues: Cloud Native Runtimes

- Resolved issue with DomainMapping names longer than 63 characters when auto-tls is enabled,
which is on by default.
- Resolved issue with certain app name, namespace, and domain combinations producing invalid
HTTPProxy resources.

#### <a id="1-5-0-namespace-provisioner-ri"></a> v1.5.0 Resolved issues: Namespace Provisioner

- Updated default resources to avoid ownership conflicts with the `grype` package.

#### <a id="1-5-0-tap-gui-plug-in-ri"></a> v1.5.0 Resolved issues: Tanzu Application Platform GUI plug-ins

- **Application Accelerator plug-in:**

  - Fixed JSON schema for Git repository creation.
  - Added missing query string parameters to accelerator provenance.

- **Application Live View plug-in:**

  - Fixed CPU stats in App Live View Steeltoe Threads and Memory pages.
  - The App Live View Details page now shows the correct boot version instead of **UNKNOWN**.
  - Fixed request parameters for the post-API call.
  - Fixed the UI error in the ALV request-mapping page that was caused by an unused style.
  - Fixed the ALV Request Mappings and Threads page to support Boot 3 apps.

#### <a id='1-5-0-tbs-ri'></a> v1.5.0 Resolved issues: Tanzu Build Service

- Builds no longer fail for upgrades on OpenShift v4.11.

#### <a id="1-5-0-apps-plugin-ri"></a> v1.5.0 Resolved issues: Tanzu CLI Apps plug-in

- Allow users to pass only `--git-commit` as Git the ref while creating a workload from a Git Repository.
  This update removes the limitation where users had to provide a `--git-tag` or `--git-branch` with the commit to create a workload.

- Fixed the behavior where `subpath` was getting removed from the workload when there are updates
  to the Git section of the workload source specification.

#### <a id="1-5-0-intellij-ext-ri"></a> v1.5.0 Resolved issues: Tanzu Developer Tools for IntelliJ

- When there are multiple resource types with the same kind, the pop-up menu **Describe** action in
  the Activity panel no longer fails when used on PodIntent resources.

---

### <a id='1-5-0-known-issues'></a> v1.5.0 Known issues

This release has the following known issues, listed by area and component.

#### <a id="1-5-0-api-auto-reg-ki"></a> v1.5.0 Known issues: API Auto Registration

- Users cannot update their APIs through API Auto Registration due to an issue with the ID used to retrieve APIs.
  This issue causes errors in the API Descriptor CRD similar to the following: `Unable to find API entity's uid within TAP GUI. Retrying the sync`.

#### <a id='1-5-0-app-config-srvc-ki'></a> v1.5.0 Known issues: Application Configuration Service

- Client applications that include the `spring-cloud-config-client` dependency might fail to start or
  properly load the configuration that Application Configuration Service produced.

- Installation might fail because the pod security context does not perfectly adhere to the
  restricted pod security standard.

#### <a id='1-5-0-bitnami-services-ki'></a> v1.5.0 Known issues: Bitnami Services

- If you try to configure private registry integration for the Bitnami services
  after having already created a claim for one or more of the Bitnami services using the default
  configuration, the updated private registry configuration does not appear to take effect.
  This is due to caching behavior in the system which is not accounted for during configuration updates.
  For a workaround, see [Troubleshoot Bitnami Services](bitnami-services/how-to-guides/troubleshooting.hbs.md#private-reg).

#### <a id='1-5-0-crossplane-ki'></a> v1.5.0 Known issues: Crossplane

- Crossplane Providers do not transition to `HEALTHY=True` if using a custom certificate for your registry.
  For more information and a workaround, see [Troubleshoot Crossplane](./crossplane/how-to-guides/troubleshooting.hbs.md#cp-custom-cert).

- Crossplane Providers cannot communicate with systems using a custom CA.
  For more information and a workaround, see [Troubleshoot Crossplane](./crossplane/how-to-guides/troubleshooting.hbs.md#cp-custom-cert-inject).

#### <a id='1-5-0-eventing-ki'></a> v1.5.0 Known issues: Eventing

- When using vSphere sources in Eventing, the vsphere-source is using a high number of
  informers to alleviate load on the API server. This causes high memory utilization.

#### <a id="1-5-0-external-secrets-ki"></a> v1.5.0 Known issues: External Secrets CLI (beta)

- The external-secrets plug-in creating the `ExternalSecret` and `SecretStore` resources through stdin
  incorrectly confirms resource creation. Use `-f ` to create resources using a file instead of stdin.

#### <a id="1-5-0-grype-scan-ki"></a> v1.5.0 Known issues: Grype scanner

- **Scanning Java source code that uses Gradle package manager might not reveal
  vulnerabilities:**

  For most languages, source code scanning only scans files present in the
  source code repository. Except for support added for Java projects using
  Maven, no network calls fetch dependencies. For languages using dependency
  lock files, such as golang and Node.js, Grype uses the lock files to verify
  dependencies for vulnerabilities.

  For Java using Gradle, dependency lock files are not guaranteed, so Grype uses
  dependencies present in the built binaries, such as `.jar` or `.war` files.

  Grype fails to find vulnerabilities during a source scan because VMware
  discourages committing binaries to source code repositories. The
  vulnerabilities are still found during the image scan after the binaries are
  built and packaged as images.

#### <a id='1-5-0-stk-ki'></a> v1.5.0 Known issues: Services Toolkit

- Unexpected error if `additionalProperties` is `true` in a CompositeResourceDefinition.
  For more information and a workaround, see [Troubleshoot Services Toolkit](./services-toolkit/how-to-guides/troubleshooting.hbs.md#compositeresourcedef).

- Default cluster-admin IAM roles on GKE do not allow you to claim Bitnami Services.
  For more information and a workaround, see [Troubleshoot Services Toolkit](./services-toolkit/how-to-guides/troubleshooting.hbs.md#default-cluster-admin).

#### <a id='1-5-0-scc-ki'></a> v1.5.0 Known issues: Supply Chain Choreographer

- When using the Carvel Package Supply Chains, if the operator updates the parameter
  `carvel_package.name_suffix`, existing workloads incorrectly output a Carvel package to the GitOps
  repository that uses the old value of `carvel_package.name_suffix`.
  You can ignore or delete this package.

#### <a id='1-5-0-tap-gui-ki'></a> v1.5.0 Known issues: Tanzu Application Platform GUI

- The portal might partially overlay text on the Security Banners customization at the bottom.

- The **Impacted Workloads** table is empty on the **CVE and Package Details** pages if the relevant
  CVE belongs to a workload that has only completed one type of vulnerability scan
  (either image or source).
  A fix is planned for a later patch.

#### <a id="1-5-0-apps-plugin-ki"></a> v1.5.0 Known issues: Tanzu CLI Apps plug-in

- `tanzu apps workload apply` does not wait for the changes to be taken when the workload is updated
  using `--tail` or `--wait`. Instead it fails if the status before the changes shows an error.

#### <a id='1-5-0-intellij-plugin-ki'></a> v1.5.0 Known issues: Tanzu Developer Tools for IntelliJ

- The error `com.vdurmont.semver4j.SemverException: Invalid version (no major version)` is shown in the
  error logs when attempting to perform a workload action before installing the Tanzu CLI apps
  plug-in.

- The `apply` action prompts and stores the workload file path when using the action for the first
  time, but modifying it afterwards is not possible.
  If the workload file location changes you must delete the module's key-value entries to delete the
  configuration.
  These entries are prefixed with `com.tanzu` in `PropertiesComponent` in the project's
  `.idea/workspace.xml` file. The next `apply` action run prompts for new values again.

- If you restart your computer while running Live Update without terminating the Tilt
  process beforehand, there is a lock that incorrectly shows that Live Update is still running and
  prevents it from starting again.
  To resolve this, delete the Tilt lock file. The default location for the file is
  `~/.tilt-dev/config.lock`.

- On Windows, workload actions do not work when in a project with spaces in the name such as
  `my-app project`.
  For more information, see [Troubleshooting](intellij-extension/troubleshooting.hbs.md#projects-with-spaces).

- In the Tanzu Activity Panel, the `config-writer-pull-requester` of type `Runnable` is incorrectly
  categorized as **Unknown**. The correct category is **Supply Chain**.

#### <a id='1-5-0-vs-plugin-ki'></a> v1.5.0 Known issues: Tanzu Developer Tools for Visual Studio

- Clicking the red square Stop button in the Visual Studio top toolbar can cause a workload to fail.
  For more information, see [Troubleshooting](vs-extension/troubleshooting.hbs.md#stop-button).

#### <a id='1-5-0-vscode-plugin-ki'></a> v1.5.0 Known issues: Tanzu Developer Tools for VS Code

- If you restart your computer while running Live Update without terminating the Tilt
  process beforehand, there is a lock that incorrectly shows that Live Update is still running and
  prevents it from starting again. Delete the Tilt lock file to resolve this.
  The default file location is `~/.tilt-dev/config.lock`.

- On Windows, workload commands don't work when in a project with spaces in the name, such as
  `my-app project`.
  For more information, see [Troubleshooting](vscode-extension/troubleshooting.hbs.md#projects-with-spaces).

- If your kubeconfig file `~/.kube/config` is malformed, you cannot apply a workload.
  You see an error message when you attempt to do so. To resolve this, fix the kubeconfig file.

- In the Tanzu Activity Panel, the `config-writer-pull-requester` of type `Runnable` is incorrectly
  categorized as **Unknown**. The correct category is **Supply Chain**.

#### <a id='1-5-0-tanzu-source-controller-ki'></a> v1.5.0 Known issues: Tanzu Source Controller

- In v0.7.0, when pulling images from Elastic Container Registry (ECR), Tanzu Source Controller
  keyless access to ECR through AWS IAM role binding fails to authenticate (error code: 401).
  The workaround is to set up a standard Kubernetes secret with a user-id and password to authenticate
  to ECR, instead of binding Tanzu Source Controller to an AWS IAM role to pull images from ECR.

---

## <a id='1-5-deprecations'></a> Deprecations

The following features, listed by component, are deprecated.
Deprecated features will remain on this list until they are retired from Tanzu Application Platform.

### <a id="1-5-alv-deprecations"></a> Application Live View deprecations

- `appliveview_connnector.backend.sslDisabled` is deprecated and marked for removal in
  Tanzu Application Platform v1.7.0.
  For more information about the migration, see [Deprecate the sslDisabled key](app-live-view/install.hbs.md#deprecate-the-ssldisabled-key).

### <a id='1-5-app-sso-deprecations'></a> Application Single Sign-On (AppSSO) deprecations

- `ClientRegistration` resource `clientAuthenticationMethod` field values `post` and `basic` are
  deprecated and marked for removal in Tanzu Application Platform v1.7.0.
  Use `client_secret_post` and `client_secret_basic` instead.

- `AuthServer.spec.tls.disabled` is deprecated and marked for removal in Tanzu Application Platform v1.6.0.
  For more information about how to migrate to `AuthServer.spec.tls.deactivated`, see
  [Migration guides](app-sso/upgrades/index.md#migration-guides).

### <a id="1-5-0-stk-deprecations"></a> Services Toolkit deprecations

- The `tanzu services claims` CLI plug-in command is now deprecated. It is
  hidden from help text output, but continues to work until officially removed
  after the deprecation period. The new `tanzu services resource-claims` command
  provides the same function.

### <a id="1-5-scst-scan-deprecations"></a> Supply Chain Security Tools (SCST) - Scan deprecations

- The `docker` field and related sub-fields used in SCST -
  Scan are deprecated and marked for removal in Tanzu Application Platform
  v1.7.0.

   The deprecation impacts the following components: Scan Controller, Grype Scanner, and Snyk Scanner.
   Carbon Black Scanner is not impacted.
   For information about the migration path, see
   [Troubleshooting](scst-scan/observing.hbs.md#unable-to-pull-scanner-controller-images).

### <a id="1-5-tbs-deprecations"></a> Tanzu Build Service deprecations

- The Ubuntu Bionic stack is deprecated: Ubuntu Bionic stops receiving support in April 2023.
  VMware recommends you migrate builds to Jammy stacks in advance.
  For how to migrate builds, see [Use Jammy stacks for a workload](tanzu-build-service/dependencies.md#using-jammy).

- The Cloud Native Buildpack Bill of Materials (CNB BOM) format is deprecated.
  VMware plans to deactivate this format by default in Tanzu Application Platform v1.6.1 and remove
  support in Tanzu Application Platform v1.8.
  To manually deactivate legacy CNB BOM support, see [Deactivate the CNB BOM format](tanzu-build-service/install-tbs.md#deactivate-cnb-bom).

### <a id="1-5-apps-plugin-deprecations"></a> Tanzu CLI Apps plug-in deprecations

- The default value for the
  [--update-strategy](./cli-plugins/apps/command-reference/workload_create_update_apply.hbs.md#update-strategy)
  flag will change from `merge` to `replace` in Tanzu Application Platform v1.7.0.

- The `tanzu apps workload update` command is deprecated and marked for removal
  in Tanzu Application Platform v1.6.0. Use the command `tanzu apps workload apply` instead.

---

## Linux Kernel CVEs

Kernel level vulnerabilities are regularly identified and patched by Canonical.
Tanzu Application Platform releases with available images, which might contain known vulnerabilities.
When Canonical makes patched images available, Tanzu Application Platform incorporates these fixed
images into future releases.

The kernel runs on your container host VM, not the Tanzu Application Platform container image.
Even with a patched Tanzu Application Platform image, the vulnerability is not mitigated until you
deploy your containers on a host with a patched OS. An unpatched host OS might be exploitable if
the base image is deployed.
