import React from 'react'
import Navbar from './Components/Navbar'
import { Web3ModalProvider } from './Components/web3model'

const page = () => {
  return (
    <div>
      <Web3ModalProvider>
      <Navbar />
      </Web3ModalProvider>


    </div>
  )
}

export default page