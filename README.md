Color Opponency
===============

MATLAB functions exploring color opponency concepts inspired by visual
neural pathways.

```
>> img = imread('peppers.png');
>> pLGN(img, 'display');
>> V1SingleOpponent(img, 'display');
>> [pLo, mLo, pMo, mMo, pSo, mSo] = pLGN(img);
>> [light, dark, red, yellow, green, blue] = V1SingleOpponent(img);
```
