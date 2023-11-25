import puppeteer from "puppeteer-extra";
import { executablePath } from "puppeteer";
import * as cheerio from 'cheerio';

import { insertCafeInfo } from "../service/crawl.js";

export const crawlstarBucksInfo = async (req, res) => {
    try {

        const browser = await puppeteer.launch({

            headless: false,
            executablePath : '/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
        });
        console.log(browser);

        const page = await browser.newPage();
        await page.setViewport({ width: 1280, height: 800 });
        await new Promise(resolve => setTimeout(resolve, 2000));

        await page.goto('https://www.starbucks.co.kr/store/store_map.do?disp=locale');

        //서울 버튼 클릭
        await page.waitForSelector('#container > div > form > fieldset > div > section > article.find_store_cont > article > article:nth-child(4) > div.loca_step1 > div.loca_step1_cont > ul > li:nth-child(1) > a');
        await page.click('#container > div > form > fieldset > div > section > article.find_store_cont > article > article:nth-child(4) > div.loca_step1 > div.loca_step1_cont > ul > li:nth-child(1) > a');

        await page.waitForSelector('#mCSB_2_container > ul > li:nth-child(1) > a');

        await page.click('#mCSB_2_container > ul > li:nth-child(1) > a');

        await new Promise(resolve => setTimeout(resolve, 1000)); // waits for 1 second


    //HTML 가져오기
        const html = await page.content();


    //Cheerio를 사용하여 매장 정보 추출
        const $ = cheerio.load(html);
        await page.waitForSelector('#mCSB_2_container > ul > li:nth-child(1) > a', { timeout: 2000 });

        const Info = $('#mCSB_3_container > ul > li').map((_, el) => {
            const name = $(el).data('name');
            const lat = $(el).data('lat');
            const lng = $(el).data('long');
            const address = $(el).find('.result_details').text().trim();
            const number = address.match(/\d{4}-\d{4}/)[0];

            return { name, address, number, lat, lng };
        }).get();

        console.log($('#mCSB_3_container > ul > li').length);
        console.log($('#mCSB_3_container > ul > li').html());


        for (var i = 0; i < Info.length; i++) {
            const myName = Info[i].name
            const myLat = Info[i].lat
            const myLng = Info[i].lng
            const myAddress = Info[i].address
            const myNumber = Info[i].number


            await insertCafeInfo(myName, myLat, myLng, myAddress, myNumber);

        }


    } catch (err) {

        console.log(err);
    }

};