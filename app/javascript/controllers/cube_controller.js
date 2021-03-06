import { Controller } from "stimulus"

import { createCubeKeyframes } from '../cubemath'
import { createElementFromHTML } from '../utils'

const animationDuration = 1400

export default class extends Controller {
  static targets = [ 'cubeContainer', 'frontSide' ]

  connect () {
    if (false && process.env.NODE_ENV === 'development') {
      if (!window.keyFramesCreated) {
        createCubeKeyframes()
        window.keyFramesCreated = true
      }
    }
  }

  onRender (event) {
    if (window.previousFrontSide) {
      this.transitionToNewContent(window.previousFrontSide, window.previousBG)

      window.previousFrontSide = null
    }
  }

  onBeforeVisit (event) {
    window.previousBG = this.getBG(this.getCubeBackground())
    window.previousFrontSide = this.getFrontSide().innerHTML.toString()
  }

  getBG = (elem) => elem.dataset.bg

  getCubeContainer = () => document.querySelector('#cube-container')
  getFrontSide = () => document.querySelector('#cube .front .side-inner')
  getCubeBackground = () => document.querySelector('#cube-container .cube-bg')

  transitionToNewContent (oldContent, oldBG) {
    const frontSide = this.getFrontSide()
    if (frontSide) {
      const content = frontSide.innerHTML
      frontSide.innerHTML = oldContent
      this.transitionBackground(oldBG)
      setTimeout(() => {
        this.rotate()
      }, 10)

      setTimeout(() => {
        frontSide.innerHTML = content
      }, animationDuration / 2)
    }
  }

  transitionBackground (oldBG) {
    const background = this.getCubeBackground()
    const newBG = this.getBG(background)
    const backgroundCL = background.classList
    backgroundCL.remove(newBG)
    backgroundCL.add(oldBG, 'changing')
    setTimeout(() => {
      backgroundCL.remove(oldBG)
      backgroundCL.add(newBG)
    }, 1000)
  }

  rotate () {
    const container = this.getCubeContainer()
    container.classList.add('rotating')
    setTimeout(() => {
      container.classList.remove('rotating')
    }, animationDuration)
  }
}
