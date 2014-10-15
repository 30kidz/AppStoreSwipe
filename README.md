AppStoreSwipe
=============

http://tk-ota.github.io/AppStoreSwipe/


![screenshot](http://tk-ota.github.io/AppStoreSwipe/images/screenshot.png)

## How to use

```html
<div id="swipe-large" class="swipe">
  <ul>
    <li><a href="#"><img src="images/302x148.png" alt=""></a></li>
    <li><a href="#"><img src="images/302x148.png" alt=""></a></li>
    <li><a href="#"><img src="images/302x148.png" alt=""></a></li>
    <li><a href="#"><img src="images/302x148.png" alt=""></a></li>
    <li><a href="#"><img src="images/302x148.png" alt=""></a></li>
    <li><a href="#"><img src="images/302x148.png" alt=""></a></li>
    <li><a href="#"><img src="images/302x148.png" alt=""></a></li>
    <li><a href="#"><img src="images/302x148.png" alt=""></a></li>
  </ul>
</div>
```

```javascript
new Swipe(document.getElementById('swipe-large'), {
  number: 1.8
});
```
