# OpenNFT


[![logo](https://github.com/user-attachments/assets/61d3311a-ca1c-4a3b-806b-1c8815e007ab)](https://apps.apple.com/si/app/nft-asset-art-maker-opennft/id6443635354)


![Badge](https://img.shields.io/badge/%EF%A3%BF%20OpenNFT-1.5.2-blue?style=plastic)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

![2](https://github.com/user-attachments/assets/d2a88660-b8c7-48e1-9fc7-584660a4b15e)




OpenNFT is an application for creating custom NFT assets! 
<br />
It's built entirely in SwiftUI, making it fast, lightweight, and easy to use.

It's multiplatform and works on iOS, macOS and iPadOS.

It generates images based on the traits and their odds set along with a [EIP-1155](https://eips.ethereum.org/EIPS/eip-1155) that is compatible with NFT marketplaces such as [OpenSea](https://opensea.io) 

## Features

### Traits

![3](https://github.com/user-attachments/assets/42a083d2-0176-4112-aeeb-655f0f8923a4)

A trait is 1 piece of an NFT assets.

For example
* A hat
* Eyes
* Mustache

A trait can have many images! So "A hat" trait, can have 9 hats, each a different style, colour or anything else, limited by only your creativity or AI image generation skills :)
By selecting 1 image of a trait, you can set its Rarity / Odds. 

So for example "A hat" trait can have 3 hats with varying rarity of showing up when geenrating the images such as: Red 10%, Green 40%, Blue 50%.

Options
* Trait name
* Multiple assets for each trait
* Odds
* Image frame


### Editor

<img width="1835" height="1191" alt="Screenshot 2026-03-28 at 15 10 26" src="https://github.com/user-attachments/assets/7f661cde-2aeb-4777-a515-02b1a3cc2e99" />

* Full-featured image composer!
* You can add as many traits as your memory can handle!
* Scale, Rotate, Layer, Restore changes
* Layer support - Reorder the traits to define the layering of images (Z-index)
* Pinch gesture support for Scale and Rotate
* Custom canvas size
* Save/restore workspace setup

### Export

![4](https://github.com/user-attachments/assets/03ad0ef7-b150-4267-97d3-90355119f125)

* Up to Int MAX assets export supported
* Custom resolution
* Custom background color
* The export uses a simple weight-based algorithm to select the traits image based on their probabilities when generating each image.
* Export assets based on trait settings
  

## A note on the architecture

The project is organized according to product domain to make managing and maintaining the codebase easier. The structure focuses on a specific application aspects, such as the UI, services or data models. This makes it ready for modularisation into Swift packages and ensures the code is organized and easily understood, especially for onboarding since product domain is the first thing new developers get familiar with.

It's a great starting point for learning SwiftUI. The app covers many of the basic concepts of SwiftUI, such as building layouts, working with data, and handling user interaction. By exploring the code, you can understand how to use SwiftUI in your daily life. Plus, the open-source nature of OpenNFT means you can see how real-world applications are built and get a sense of best practices for using SwiftUI.

The architecture follows vanilla Apple guidelines and API best practises and uses a straightforward MVVM for most parts.

Thanks!

<img width="1024" height="1024" alt="openNFT 001" src="https://github.com/user-attachments/assets/12c959de-4dcf-4d82-99f7-eaffa78ac9ae" />


## Building the project

To build the project, you need to clone the repo and run it.
This project is a pruned copy-paste of my private project, but I decided it will be more useful as open source / showcase.

Here are the steps:

1. Clone the repo
2. Run
